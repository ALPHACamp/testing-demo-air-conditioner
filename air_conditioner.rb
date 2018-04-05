# 冷氣
class AirConditioner
  attr_accessor :ispower

  def initialize
    @isopen = false
    @ispower = false
  end

  def open!
    @isopen = true
  end

  # 出風口
  def outlet_status
    if @isopen
      'wind~~~'
    else
      'nothing'
    end
  end

  # 指令接收器
  def receiver order
    case order
    when 'check_is_opened'
      return @isopen
    when 'open'
      if @ispower
        self.open!
      else
        raise 'Try again after connecting with power'
      end

      true
    else
      return 'unknown order'
    end
  end
end

# 冷氣遙控器
class AirConditionerController
  def initialize ac
    @ac = ac
    @dashboard = {
      status: 'off'
    }
  end

  def print_dashboard
    puts @dashboard
  end

  def open
    # 紅外線發射器 = 紅外線模組載入
    require './ir'
    ir = IR.new

    # 設定指令 -> 確認冷氣是否開啟
    @order = 'check_is_opened'
    # 設定發射器 -> 紅外線發射器
    @launcher = ir
    # 開啟狀態 = 發送問題給冷氣
    isopen = self.class.send(@ac, @order)

    # if 開啟狀態 == 沒開
    if isopen == false
      # 設定開機為要執行的指令
      @order = 'open'
      # 選擇透過紅外線發送
      @launcher = ir
      # 結果 = 發送開機指令
      result = self.class.send(@ac, @order)

      # if 結果 == 成功
      if result
        # 於冷氣遙控器儀表板上顯示 on
        @dashboard[:status] = 'on'
      else
        # 於設定冷氣遙控器儀表板上顯示 off
        @dashboard[:status] = 'off'
      end
    end
  end

  def self.send ac, order
    ac.receiver(order)
  end
end
