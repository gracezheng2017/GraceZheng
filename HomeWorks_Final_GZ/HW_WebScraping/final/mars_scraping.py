# https://splinter.readthedocs.io/en/latest/drivers/chrome.html
from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
import pymongo

def init_browser():
    
    executable_path = {'executable_path': 'chromedriver.exe'}
    browser = Browser('chrome', **executable_path, headless=False)
    return browser


def scrape():
    browser = init_browser()
    news_url = 'https://mars.nasa.gov/news/'
    browser.visit(news_url)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')

    # 1 -- NASA Mars News
    slides = soup.find_all('div', class_='slide')
    for slide in slides:
        news_title = soup.find('div', class_="content_title").text
        news_p = soup.find('div', class_="article_teaser_body").text

        print(news_title)
        print(news_p)
        break


    browser = init_browser()
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)

    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')

    #2 -- scrape the img
    imgs = soup.find_all('a', class_='fancybox')
    for img in imgs:
        if 'Mars' in img.get('data-description'):
            #print('https://www.jpl.nasa.gov'+img.get('data-fancybox-href'))
            featured_image_url = 'https://www.jpl.nasa.gov'+img.get('data-fancybox-href')
            print(featured_image_url)
            break


    browser = init_browser()
    url2 = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(url2)

    html2 = browser.html
    soup2 = BeautifulSoup(html2, 'html.parser')

    #3 -- scrape the Mars weather from twitter
    div = soup2.find('div', class_='js-tweet-text-container')
    mars_weather = soup2.find('p', class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text").text
    print(mars_weather)
    #weather=div.text

    # 4 -- Mars facts
    url_facts='https://space-facts.com/mars/'
    facts_table = pd.read_html(url_facts)
    facts_table
    df=facts_table[0]
    df.columns=['description','value']
    df.head()

    html_table = df.to_html()
    html_table
    html_table.replace('\n', '')
    #df.to_html('table.html')

    #5--Mars hemisphere images
    hemisphere_image_urls = [
        {"title": "Valles Marineris Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/valles_marineris_enhanced.tif/full.jpg"},
        {"title": "Cerberus Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg"},
        {"title": "Schiaparelli Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg"},
        {"title": "Syrtis Major Hemisphere", "img_url": "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/syrtis_major_enhanced.tif/full.jpg"},
    ]


# conn = 'mongodb://localhost:27017'
# client = pymongo.MongoClient(conn)

# # Declare the database
# db = client.mars_db

# # Declare the collection
# collection = db.mars_coll

    mars_data = {}
    mars_data['news_title']=news_title
    mars_data['news_p']=news_p
    mars_data['featured_image_url']=featured_image_url
    mars_data['mars_weather']=mars_weather
    mars_data['facts']=df
    mars_data['Valles Marineris Hemisphere']='https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/valles_marineris_enhanced.tif/full.jpg'
    mars_data['Cerberus Hemisphere']='https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/cerberus_enhanced.tif/full.jpg'
    mars_data['Schiaparelli Hemisphere']='https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/schiaparelli_enhanced.tif/full.jpg'
    mars_data['Syrtis Major Hemisphere']='https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/syrtis_major_enhanced.tif/full.jpg'
    
#     mars = {
#         'hemisphere_image_urls': "https://astropedia.astrogeology.usgs.gov/download/Mars/Viking/valles_marineris_enhanced.tif/full.jpg"
#     #     'vendor': 'fruit star',
#     #     'fruit': 'raspberry',
#     #     'quantity': 21,
#     #     'ripeness': 2,
#     #     'date': datetime.datetime.utcnow()  
#         #datetime.datetime(2018, 4, 20, 1, 48, 47, 972355)
#     }

#     collection.insert_one(mars)




# # Verify results:
# results = db.mars_db.find()
# for result in results:
#     print(result)