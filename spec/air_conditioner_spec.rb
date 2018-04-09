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
end
