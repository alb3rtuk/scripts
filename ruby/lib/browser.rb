class Browser

    ClickCustom = "ClickCustom"
    ClickInput = "ClickInput"
    ClickLink = "ClickLink"
    Frame = "Frame"
    GetSecurityForLabel = "GetSecurityForLabel"
    GetSecurityForCustom = "GetSecurityForCustom"
    Goto = "Goto"
    IfExists = "IfExists"
    SetTextField = "SetTextField"
    SetSelectField = "SetSelectField"
    TickCheckbox = "TickCheckbox"
    ToPrefix = "ToPrefix"
    ToSuffix = "ToSuffix"

    # Public Constructor
    # @return void
    def initialize(browserType = 'chrome', displays = 'single')
        verifyInput(Array['ff', 'chrome', 'phantomjs'], browserType)
        verifyInput(Array['single', 'multiple'], displays)
        if (displays == 'single')
            width = 1680
            height = 2000
            x = 0
            y = -0
        elsif (displays == 'multiple')
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
        @frame = ''
        @ifExists = false
    end

    # Gets the action array based on the previous action.
    # @return array
    def getActionArray()
        if (@usePrevious == true)
            action = @actions.pop
        elsif action = Array.new
        end
        @usePrevious = false
        return action
    end

    # Magical method that appends a value to the currently 'active' action array.
    # @return self
    def to(value)
        action = @actions.pop
        action.push(value)
        @actions.push(action)
        return self
    end

    # Adds a prefix to the .to() value, currently only used by <select> option
    # @return void
    def toPrefix(value)
        action = @actions.pop
        action.push(ToPrefix)
        action.push(value)
        @actions.push(action)
    end

    # Adds a suffix to the .to() value, currently only used by <select> option
    # @return void
    def toSuffix(value)
        action = @actions.pop
        action.push(ToSuffix)
        action.push(value)
        @actions.push(action)
    end


    # Magical method which performs an action on a specific frame.
    # @return void
    def frame(value)
        action = Array.new
        action.push(Frame)
        action.push(value)
        @actions.push(action)
        @usePrevious = true
        return self
    end

    # Goto URL
    # @return void
    def goto(url)
        action = Array.new
        action.push(Goto)
        action.push(url)
        @actions.push(action)
    end

    # Click a custom element
    # @return void
    def clickCustom(params)
        action = self.getActionArray()
        action.push(ClickCustom)
        action.push(params)
        @actions.push(action)
    end

    # Click an input button
    # @return void
    def clickInput(params)
        action = self.getActionArray()
        action.push(ClickInput)
        action.push(params)
        @actions.push(action)
    end

    # Click an <a> tag
    # @return void
    def clickLink(params)
        action = self.getActionArray()
        action.push(ClickLink)
        action.push(params)
        @actions.push(action)
    end

    # Set a value on a input[type=text] field
    # @return self
    def setTextField(params)
        action = self.getActionArray()
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
        action = self.getActionArray()
        action.push(TickCheckbox)
        action.push(params)
        action.push(true)
        @actions.push(action)
    end

    # UnTick a checkbox
    # @return void
    def unTickCheckbox(params)
        action = self.getActionArray()
        action.push(TickCheckbox)
        action.push(params)
        action.push(false)
        @actions.push(action)
    end

    # Retrieves the security character for a label
    # @return self
    def getSecurityForLabel(params)
        action = self.getActionArray()
        action.push(GetSecurityForLabel)
        action.push(params)
        @actions.push(action)
        @usePrevious = true;
        return self
    end

    # Retrieves the security character for a custom HTML element definition, must start with 'browser.*'
    # @return self
    def getSecurityForCustom(params)
        action = self.getActionArray()
        action.push(GetSecurityForCustom)
        action.push(params)
        @actions.push(action)
        @usePrevious = true
        return self
    end

    # Makes the following action optional
    # @return self
    def ifExists()
        action = Array.new
        action.push(IfExists)
        @actions.push(action)
        @usePrevious = true
        return self
    end

    # Runs all the actions in test mode.
    # @return void
    def executeAsTest
        self.execute(true)
    end

    # Execute commands.
    # @return void
    def execute(asTest = false)
        @browser = Watir::Browser.new(@browserType)
        @browser.window.move_to(@browserX, @browserY)
        @browser.window.resize_to(@browserWidth, @browserHeight)
        @actions.each do |action|
            # Frame needs to be checked before 'ifExists' so that if we
            # want, we can use both (IE: browser.frame(XXX).ifExists().setTextField() ... etc.)
            if (action.at(0) == Frame)
                @frame = ".frame(#{action.at(1)})"
                action.shift
                action.shift
            else
                @frame = ''
            end

            # IfExists check..
            if (action.at(0) == IfExists)
                @ifExists = true
                action.shift
            else
                @ifExists = false
            end

            if inArray(Array[SetSelectField, SetTextField], action.at(0))
                self.executeSet(action)
                next if 1 == 1
            end

            exists = true
            case action.at(0)
                when ClickCustom
                    if (@ifExists == true)
                        eval("exists = @browser#{@frame}.#{action.at(1)}.exists?")
                    end
                    if (exists == true)
                        eval("@browser#{@frame}.#{action.at(1)}.click")
                    end
                when ClickInput
                    if (@ifExists == true)
                        eval("exists = @browser#{@frame}.input(#{action.at(1)}).exists?")
                    end
                    if (exists == true)
                        eval("@browser#{@frame}.input(#{action.at(1)}).click")
                    end
                when ClickLink
                    if (@ifExists == true)
                        eval("exists = @browser#{@frame}.link(#{action.at(1)}).exists?")
                    end
                    if (exists == true)
                        eval("@browser#{@frame}.link(#{action.at(1)}).click")
                    end
                when GetSecurityForLabel
                    charAt = false
                    eval("charAt = @browser#{@frame}.label(#{action.at(1)}).text.scan(/\\d/).join('')")
                    securityCharacter = getCharAt(charAt, action.at(4))
                    action.shift
                    action.shift
                    action.map! { | x | x == action.at(2) ? securityCharacter : x }.flatten!
                    self.executeSet(action)
                when GetSecurityForCustom
                    charAt = false
                    eval("charAt = @browser#{@frame}.#{action.at(1)}.scan(/\\d/).join('')")
                    securityCharacter = getCharAt(charAt, action.at(4))
                    action.shift
                    action.shift
                    action.map! { | x | x == action.at(2) ? securityCharacter : x }.flatten!
                    self.executeSet(action)
                when Goto
                    @browser.goto(action.at(1))
                when TickCheckbox
                    if (@ifExists == true)
                        eval("exists = @browser#{@frame}.checkbox(#{action.at(1)}).exists?")
                    end
                    if (exists == true)
                        if (action.at(2) == true)
                            eval("@browser#{@frame}.checkbox(#{action.at(1)}).set")
                        elsif eval("@browser#{@frame}.checkbox(#{action.at(1)}).clear")
                        end
                    end
            end
            @ifExists = false
        end
    end

    # Helper function for executing setters. Put here as a hack to make 'GetSecurity...' functions work.
    # This probably isn't the best way of doing this but meh... I have more pressing issues.
    # @return void
    def executeSet(action)
        prefix = self.getPrefixIfExists(action)
        suffix = self.getSuffixIfExists(action)
        exists = true
        case action.at(0)
            when SetSelectField
                if (@ifExists == true)
                    eval("exists = @browser#{@frame}.select_list(#{action.at(1)}).option(:value => '#{prefix}#{action.at(2)}#{suffix}').exists?")
                end
                if (exists == true)
                    eval("@browser#{@frame}.select_list(#{action.at(1)}).option(:value => '#{prefix}#{action.at(2)}#{suffix}').select")
                end
            when SetTextField
                if (@ifExists == true)
                    eval("exists = @browser#{@frame}.text_field(#{action.at(1)}).exists?")
                end
                if (exists == true)
                    eval("@browser#{@frame}.text_field(#{action.at(1)}).set '#{action.at(2)}'")
                end
        end
        @ifExists = false
    end

    # Sets a prefix for <select> option, if exists.
    # @return void
    def getPrefixIfExists(action)
        if(action.at(3) == ToPrefix)
            return action.at(4)
        end
        return ''
    end

    # Sets a suffix for <select> option, if exists.
    # @return void
    def getSuffixIfExists(action)
        if(action.at(3) == ToSuffix || action.at(5) == ToSuffix)
            return action.at(4)
        end
        return ''
    end

end