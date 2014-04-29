require 'rubygems'
require 'selenium-webdriver'

dr=Selenium::WebDriver.for :firefox
url="http://edge.edx.org"
dr.get url

email=dr.find_elements(:xpath, '//input[@name="email"]')
email[0].send_keys('wei.xu.0@gmail.com')

passbox=dr.find_elements(:xpath, '//input[@name="password"]')
passbox[0].send_keys('tsinghuaedx')

submitbutton=dr.find_elements(:xpath, '//input[@name="submit"]')
submitbutton[0].click

sleep 5

courselink=dr.find_elements(:xpath, '//a[text()="6.BDx Tackling the Challenges of Big Data"]')
courselink[0].click

sleep 5

courseware=dr.find_elements(:xpath, '//a[contains(text(),"Courseware")]')
courseware[0].click

sleep 5

cnt = 0
urls = []
texts = []
links=dr.find_elements(:xpath,'//a')
links.each { |l|
  url = l.attribute("href")
  if url =~ /.*courseware.*/
    urls << url
    texts << l.attribute("text")
    p cnt
    p l.attribute("href")
    p l.attribute("text")
    cnt += 1
  end

}

cnt = 0
urls.each { |l|
  p "============"
  p "going to :"
  p cnt
  p l
  dr.navigate.to l
  content = dr.page_source.to_str

  p content

  File.open("/Users/xuw/big_data_course/#{cnt}.html", 'w') { |file|
    file.puts(content)
  }
  cnt += 1
  sleep 1
}



# sleep 3
# dr.switch_to.frame('mainFrame')
# sleep 3
#
# config=dr.find_elements(:xpath, '//a[text()="Configuration"]')
#
# config[0].click
#
# ntp=dr.find_elements(:xpath, '//a[text()="NTP"]')
# ntp[0].click
#
# sleep 3
#
# dr.switch_to.frame('pageFrame')
#
# server=dr.find_elements(:xpath, '//input[@id="_txtNTPServer"]')
# if server[0].enabled?
#   server[0].clear
#   server[0].send_keys("10.1.0.201")
# end
#
# enable=dr.find_elements(:xpath, '//input[@id="_chkNTPEnable"]')
# if enable[0].enabled?
#   enable[0].click
# end
#
# # refresh=dr.find_elements(:xpath, '//input[@id="_btnRefresh"]')
# # refresh[0].click
#
# save=dr.find_elements(:xpath, '//input[@id="_btnSave"]')
# save[0].click
#
# sleep 2
# alert = dr.switch_to.alert
# if alert
#   alert.accept
# end
#
# sleep 2
# dr.close
#
# p "done with #{ARGV[0]}"