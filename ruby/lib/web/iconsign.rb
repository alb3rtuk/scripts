class IConsign

    def initialize(username, password)
        @username = username
        @password = password
    end

    def login(displays, headless = false)
        browser = getBrowser(displays, headless)
        browser.goto('https://iconsign.ukmail.com/IConsign/Index.aspx?Action=sessionexpired')
        sleep(3)
        browser.text_field(:name => 'txtUsername').set @username
        browser.text_field(:name => 'txtPassword').set @password
        browser.input(:type => 'submit', :name => 'btnLogin').click
        browser
    end

    def processOrder(browser, name, address1, address2, city, county, postcode, phone, email, reference, items, weight, userID)
        browser.text_field(:name => 'ctl00$mainContent$contact').set name
        browser.text_field(:name => 'ctl00$mainContent$customerRef').set userID
        browser.text_field(:name => 'ctl00$mainContent$alternativeRef').set reference
        browser.text_field(:name => 'ctl00$mainContent$telephone').set phone
        browser.text_field(:name => 'ctl00$mainContent$emailAddress').set email
        browser.text_field(:name => 'ctl00$mainContent$postCode').set postcode
        browser.checkbox(:id => 'ctl00_mainContent_signatureOptional').click
        sleep(1)
        browser.link(:id => 'mb_close_link').click
        browser.text_field(:name => 'ctl00$mainContent$address1').set address1
        browser.text_field(:name => 'ctl00$mainContent$address2').set address2
        browser.text_field(:name => 'ctl00$mainContent$postalTown').set city
        browser.text_field(:name => 'ctl00$mainContent$county').set county
        browser.text_field(:name => 'ctl00$mainContent$domesticItems').set items
        browser.text_field(:name => 'ctl00$mainContent$domesticWeight').set weight
        browser.input(:type => 'radio', :id => 'ctl00_mainContent_preDelEmail').click
        browser
    end

    def getSentConsignments(browser)
        browser.goto('https://iconsign.ukmail.com/IConsign/FindConsignments.aspx')

        totalPages = browser.span(:id => 'ctl00_mainContent_resultLabel').text
        totalPages = totalPages.gsub(/[^0-9]/, '').to_f
        totalPages = totalPages / 20
        totalPages = totalPages.ceil
        currentPage = 1
        consignmentData = Array.new


        until currentPage > totalPages
            puts "Currently on: Page #{currentPage}"
            browser.execute_script("javascript:__doPostBack('ctl00$mainContent$consignmentGridView','Page$#{currentPage}')")
            table = browser.table(:id => 'ctl00_mainContent_consignmentGridView')
            tableRowCount = 0
            table.rows.each do |tableRow|
                tableRowCount = tableRowCount + 1
                if tableRowCount == 1
                    next
                end
                rowData = {}
                cellCount = 0
                tableRow.cells.each do |tableCell|
                    cellCount = cellCount + 1
                    if cellCount == 5
                        rowData['customerRef'] = tableCell.text
                    elsif cellCount == 6
                        rowData['altRef'] = tableCell.text
                    elsif cellCount == 7
                        rowData['consignmentNumber'] = tableCell.text
                    elsif cellCount == 8
                        rowData['collectionDate'] = tableCell.text
                    elsif cellCount == 10
                        rowData['postCode'] = tableCell.text
                    end
                end
                consignmentData << rowData
            end
            consignmentData.pop
            currentPage = currentPage + 1
        end

        lastColletionDate = 0
        output = ''

        consignmentData.each do |consignment|
            if lastColletionDate != consignment['collectionDate']
                output.insert(0, "\n")
            end
            output.insert(0, "#{consignment['collectionDate']} - #{consignment['consignmentNumber']} - #{consignment['altRef']} - #{consignment['customerRef']} - #{consignment['postCode']}\n")
            lastColletionDate = consignment['collectionDate']
        end

        File.open('/tmp/iconsign-fix.txt', 'w') { |file| file.write(output) }
    end

end