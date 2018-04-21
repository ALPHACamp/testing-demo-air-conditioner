require './air_conditioner'

RSpec.describe AirConditionerController, "acc" do
  before do
    @ac = AirConditioner.new
    @acc = AirConditionerController.new @ac
  end

  # 2-2
  it "should open button work" do
    # 假設冷氣有插著插頭
    @ac.ispower = true
    # 確認冷氣出風口沒有出風
    expect(@ac.outlet_status).to eq('nothing')
    # 打開冷氣
    @acc.open()
    # 感覺到冷氣出風口開始出風
    expect(@ac.outlet_status).to eq('wind~~~')
  end

  # 2-3
  # model
  it "should check_if_ac_open? would return true" do
    isopen = true
    # 假的紅外線 = 建立假的紅外線
    ir = double(IR)
    # 假設 發送問題給冷氣 回傳值為 真
    allow(@ac).to receive(:receiver).and_return(isopen)
    # 預期(冷氣.判斷是否開啟(假的紅外線)) == 真
    expect(@acc.check_if_ac_open?(ir)).to eq(isopen)
  end

  it "should check_if_ac_open? would return false" do
    isopen = false
    # 假的紅外線 = 建立假的紅外線
    ir = double(IR)
    # 假設 發送問題給冷氣 回傳值為 假
    allow(@ac).to receive(:receiver).and_return(isopen)
    # 預期(冷氣.判斷是否開啟(假的紅外線)) == 假
    expect(@acc.check_if_ac_open?(ir)).to eq(isopen)
  end

  # controller
  it "should controller open work" do
    # 假設 冷氣開啟狀態 為 靜止
    @ac.isopen = false
    @ac.ispower = true
    # 冷氣遙控器.打開冷氣()
    @acc.open
    # 預期(冷氣狀態) == 運作中
    expect(@ac.isopen).to eq(true)
  end

  # view
  it "should status in dashboard correct" do
    # 假設 冷氣開啟狀態 為 靜止
    @ac.isopen = false
    @ac.ispower = true
    # 冷氣遙控器.打開冷氣()
    @acc.open
    # 預期冷氣遙控器儀表板上 會 顯示 on
    expect(@acc.print_dashboard).to include(:status => "on")
  end

  # 2-5 定時功能
  it "should add an hour if timer less than 12" do
    # 定時時間 = 取得小於 12 的亂數
    timer = rand(0..11)
    # 冷氣定時時間 = 定時時間
    @ac.timer = timer
    # 預期定時時間 = 定時時間 + 1
    next_timer = timer + 1

    # 預期(冷氣遙控器.定時()) == 預定定時時間
    expect(@acc.set_timer).to eq(next_timer)
  end

  it "should reset timer if timer equals 12" do
    # 冷氣定時時間 = 12
    @ac.timer = 12

    # 預期(冷氣遙控器.定時()) == 0
    expect(@acc.set_timer).to eq(0)
  end

  it "should timer work" do
    # 冷氣開啟
    @ac.isopen = true
    @ac.ispower = true
    # 冷氣遙控器.定時()
    @acc.set_timer

    # 59 分鐘過後
    Timecop.freeze(Time.now + 59.minutes) do
      @ac.check_timer
      # 預期(冷氣狀態) == 開啟
      expect(@ac.isopen).to eq(true)
    end

    Timecop.return

    # 61 分鐘過後
    Timecop.freeze(Time.now + 61.minutes) do
      @ac.check_timer
      # 預期(冷氣狀態) == 關閉
      expect(@ac.isopen).to eq(false)
    end
  end

  it "should timer info be printed in dashboard" do
    # 設定 冷氣開啟
    @ac.isopen = true
    @ac.ispower = true
    # 冷氣遙控器.定時()
    @acc.set_timer

    # 預期 冷氣遙控器儀表板上 會 顯示 定時 1 小時
    expect(@acc.print_dashboard).to include(:timer => "1 hour")
  end
end
