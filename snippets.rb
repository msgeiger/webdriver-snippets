module Snippets
  def goto link
    @wd_driver.navigate.to link
  end

  def get_timestamp
    timestamp = Time.new().to_i
  end

  def get_unique_string text
    unique_string = text + self.get_timestamp
  end

  def wait_for_element locator
    @wd_wait.until { driver.find_element locator }
    element = @wd_driver.find_element locator
  end

  def wait_for_and_click locator
    @wd_wait.until { @wd_driver.find_element(locator) }
    @wd_driver.find_element(locator).click
  end

  def click locator
    @wd_driver.find_element(locator).click
  end

  def check_download_report_feature locator
    self.wait_for_and_click locator
    # Wait for the Download to... to load in document
    self.wait_for_element locator
    element = @wd_driver.find_element locator
    assert element.text.include?("Download")
  end

  def pass_in_object_check_download_report_feature element, locator
    element.click
    # Wait for the Download to... to load in document
    self.wait_for_element locator
    download_link = @wd_driver.find_element locator
    assert download_link.text.include?("Download")
  end

  def wait_for_report_to_load
    locator = {:css => "tr[id='report_row_0_0']"}
    self.wait_for_element locator
  end

  def wait_for_element locator
    driver = @wd_driver
    @wd_wait.until { driver.find_element locator }
  end

  def wait_for_element_text locator
    result = @wd_wait.until {
      result = @wd_driver.find_element(locator).text
      result if result.length > 0
    }
    return result
  end

  def wait_for_text locator
    @wd_wait.until { 
      results = @wd_driver.find_element(locator).text 
      return results if results.length > 0
    }
  end

  def get_element_text locator
    element = @wd_driver.find_element( locator ).text
  end  

  def wait_for_and_submit locator 
    @wd_wait.until { @wd_driver.find_element locator }
    @wd_driver.find_element( locator ).submit
  end

  def wait_for_and_type locator, string
    @wd_wait.until { @wd_driver.find_element locator }
    element = @wd_driver.find_element( locator )
    element.clear
    element.send_keys string
  end

  def type locator, string
    element = @wd_driver.find_element( locator )
    element.clear
    element.send_keys string 
  end

  def get_elements_by_tag_name tags_container, tag
    element = @wd_driver.find_element( tags_container )
    elements = element.find_elements( :tag_name => tag )
  end

  def select_option locator, option_value 
    @wd_wait.until { @wd_driver.find_element locator }
    element = @wd_driver.find_element( locator )
    options = element.find_elements :tag_name => "option"
    options.each do |el|
      if el.text == option_value 
        el.click
        break
      end
    end
  end

  def select_option_does_include locator, partial_string 
    @wd_wait.until { @wd_driver.find_element locator }
    element = @wd_driver.find_element( locator )
    options = element.find_elements :tag_name => "option"
    options.each do |el|
      if el.text.include? partial_string 
        el.click
        break
      end
    end
  end

  def loop_through_options select_locator, button_locator, reporter_locator
    self.wait_for_element select_locator
    select_element = @wd_driver.find_element select_locator
    options = select_element.find_elements :tag_name => "option"

    self.wait_for_element button_locator
    button_element = @wd_driver.find_element button_locator 

    options.each do |option|
      option.click
      button_element.click
      self.wait_for_element reporter_locator
    end
  end

  def submit_form button
    if button.attribute('type') == 'submit' 
      button.submit
    else 
      button.click
    end
  end

  def loop_run_report_through_checkbox_filter not_in, container, button, reporter
    elements = self.get_elements_by_tag_name container, 'input'
    @wd_wait.until { @wd_driver.find_element button }
    button = @wd_driver.find_element button

    # Run report through filters, exclude, selectors ('checkbox' elements), we don't want.
    elements.each { |item| 
        include = not_in[:element_ids].include? item.attribute('id')
        displayed = item.displayed?
        if !include && displayed && item.attribute('id') != ''
        if item.displayed?
          # Select filter option
          item.click
        if button.attribute('type') == 'submit' 
          button.submit
        else 
          button.click
          @wd_wait.until { driver.find_element reporter }
        end
          # Unselect filter option
          item.click
        end
      end
    }
  end

  def loop_run_report_through_checkbox_filters container, button, reporter
    elements = self.get_elements_by_tag_name container, 'input'
    @wd_wait.until { @wd_driver.find_element button }
    button = @wd_driver.find_element button

    # Run report through filters.
    elements.each { |item| 
      if item.displayed?
        # Select filter
        item.click
      end
      if button.attribute('type') == 'submit' 
        button.submit
      else 
        button.click
      end
      @wd_wait.until { @wd_driver.find_element reporter }
      # Unselect filter
      item.click
    }
  end

  def parse_ndc from_string
    ndc = from_string.match( /\d{11}/ )
    hy_ndc = from_string.match( /\d{5}-\d{4}-\d{2}/ )

    if ndc
      ndc_value = ndc[0]
    end

    if hy_ndc
      ndc_value = hy_ndc[0]
      puts 'hy ' + ndc_value
    end
    ndc_value
  end

  def click_through_reporter_column_headings reporter_container
    @wd_wait.until { @wd_driver.find_element reporter_container }

    elements = self.get_elements_by_tag_name reporter_container, 'th'
    element_ids = []

    elements.each { |item|
      onclick = item.attribute('onclick')
      displayed = item.displayed?
      if onclick && displayed && onclick != ''
        element_ids.push item.attribute('id')
      end
    }

    element_ids.each { |id|
      locator = { :css => "th[id='#{id}']" }
      @wd_wait.until { @wd_driver.find_element( locator ) }
      element = @wd_driver.find_element( locator )
      if element
        element.click
        self.wait_for_report_to_load
      end
      }
  end

  def pass_in_array_click_through_reporter_column_headings element_ids
    element_ids.each { |id|
      locator = { :css => "th[id='#{id}']" }
      @wd_wait.until { @wd_driver.find_element( locator ) }
      element = @wd_driver.find_element( locator )
      if element
        element.click
      end
    }
  end
  
  def pass_in_objects_click_through_reporter_column_headings locators
    locators.each { |locator|
      @wd_wait.until { @wd_driver.find_element( locator ) }
      element = @wd_driver.find_element( locator )
      if element
        element.click
      end
    }
  end

  def clear locator
    @wd_driver.find_element( locator ).clear
  end

  def get_attribute_value locator, attribute
    @wd_driver.find_element( locator ).attribute( attribute )
  end

  def find_element_match_text pattern, tags_container, tag, count
    anchors = self.get_elements_by_tag_name tags_container, tag
    itr = 0
    anchors.each do |element|
      if pattern.match(element.text)
        itr += 1
        if itr == count
          return element
        end
      end
    end
  end

  def find_element_match_attribute pattern, tags_container, tag, attr
    elements = self.get_elements_by_tag_name tags_container, tag
    elements.each do |element|
      if pattern.match(element.attribute(attr))
        return element
      end
    end
  end

  def assert_errors_are_not_present
    @wd_wait.until { @wd_driver.execute_script("return document.body") }
    element = @wd_driver.execute_script("return document.body")
    text_string = element.text
    assert text_string.include?('ERROR') == false
    assert text_string.include?('Call Stack') == false
    assert text_string.include?('403 Forbidden') == false
    assert text_string.include?('Not Found') == false
  end
end
