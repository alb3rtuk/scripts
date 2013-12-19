require 'test/unit'

class Browser  < Test::Unit::TestCase

    ClickInput = "ClickInput"
    GetSecurityForLabel = "GetSecurityForLabel"
    Goto = "Goto"
    SetTextField = "SetTextField"
    SetSelectField = "SetSelectField"
    TickCheckbox = "TickCheckbox"

    # Public Constructor
    # @return void
    def initialize(browserType = 'chrome', displays = 'single')
        verifyInput(Array['ff', 'chrome', 'phantomjs'], browserType)
        verifyInput(Array['single', 'multiple'], displays)
        if(displays == 'single')
            width = 1440
            height = 2000
            x = 0
            y = -0
        elsif(displays == 'multiple')
            width = 1920
            height = 2000
            x = 1440
            y = -2000
        end
        @browserType = browserType
        @browserWidth = width
        @browserHeight = height
        @browserX = x
        @browserY = y
        @actions = Array.new
        # If this gets set (for example by 'getSecurityCharacter', then getActionArray appends to the current action).
        @usePrevious = false
    end

    # Gets the action array based on the previous action.
    # @return array
    def getActionArray()
        if(@usePrevious == true)
            action = @actions.pop
        elsif
            action = Array.new
        end
        @usePrevious = false
        return action
    end

    # Magical method that appends a value to the currently 'active' action array.
    def to(value)
        action = @actions.pop
        action.push(value)
        @actions.push(action)
    end

    # Magical method which performs an action on a specific frame.
    def frame(value)

    end

    # Goto URL
    # @return void
    def goto(url)
        action = Array.new
        action.push(Goto)
        action.push(url)
        @actions.push(action)
    end

    # Click an input button
    # @return void
    def clickInput(params)
        action = Array.new
        action.push(ClickInput)
        action.push(params)
        @actions.push(action)
    end

    # Set a value on a input[type=text] field
    # @return self
    def setTextField(params)
        action = Array.new
        action.push(SetTextField)
        action.push(params)
        @actions.push(action)
        return self
    end

    # Set a value on a <select> field
    # @return self
    def setSelectField(params)
        action = self.getActionArray()
        action.push(SetSelectField)
        action.push(params)
        @actions.push(action)
        return self
    end

    # Tick a checkbox
    # @return void
    def tickCheckbox(params)
        action = Array.new
        action.push(TickCheckbox)
        action.push(params)
        action.push(true)
        @actions.push(action)
    end

    # UnTick a checkbox
    # @return void
    def unTickCheckbox(params)
        action = Array.new
        action.push(TickCheckbox)
        action.push(params)
        action.push(false)
        @actions.push(action)
    end

    # Retrieves the security character required using a regex
    # @return self
    def getSecurityForLabel(params)
        action = Array.new
        action.push(GetSecurityForLabel)
        action.push(params)
        @actions.push(action)
        @usePrevious = true;
        return self
    end

    # Execute commands.
    # @return void
    def execute(asTest = false)

        @browserType = 'phantomjs'

        puts @actions.inspect
        @browser = Watir::Browser.new(@browserType)
        @browser.window.move_to(@browserX, @browserY)
        @browser.window.resize_to(@browserWidth, @browserHeight)
        @actions.each do | action |
            puts action.at(0)
            if inArray(Array[SetSelectField, SetTextField], action.at(0))
                self.executeSet(action)
                next if 1 == 1
            end
            case action.at(0)
                when ClickInput
                    eval("@browser.input(#{action.at(1)}).click")
                when GetSecurityForLabel
                    charAt = false
                    eval("charAt = @browser.label(#{action.at(1)}).text.scan(/\\d/).join('')")
                    securityCharacter = getCharAt(charAt, action.at(4))
                    action.shift
                    action.shift
                    action.pop
                    action.push(securityCharacter)
                    self.executeSet(action)
                when Goto
                    @browser.goto(action.at(1))
                when TickCheckbox
                    if(action.at(2) == true)
                        eval("@browser.checkbox(#{action.at(1)}).set")
                    elsif
                        eval("@browser.checkbox(#{action.at(1)}).clear")
                    end
            end
        end
        puts @actions.inspect
        exit
    end

    # Helper function for executing setters. Put here as a hack to make 'GetSecurity...' functions work.
    # This probably isn't the best way of doing this but meh... I have more pressing issues.
    # @return void
    def executeSet(action)

        puts action.inspect

        case action.at(0)
            when SetSelectField
                eval("@browser.select_list(#{action.at(1)}).option(:value => '#{action.at(2)}').select")
            when SetTextField
                eval("@browser.text_field(#{action.at(1)}).set '#{action.at(2)}'")
        end
    end

    # Runs all the actions in test mode.
    # @return void
    def executeAsTest
        self.execute(true)
    end
end