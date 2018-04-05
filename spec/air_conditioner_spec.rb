require './air_conditioner'

RSpec.describe AirConditionerController, "acc" do
  before do
    @ac = AirConditioner.new
    @acc = AirConditionerController.new @ac
  end

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
end
