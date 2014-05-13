# AppBox Octopress
An AppBox to display Apple Appstore or Google Play Apps to your posts in Octopress or Jekyll

## Installation

Add ```appbox-octopress``` and ```nokogiri``` gem to your Gemfile and run ```bundle install```. ```open-uri``` is part of the Ruby Standard Libs.

To install the relevant files type ```appbox-octopress install``` in the root directory of your Octopress or Jekyll installation.

### Manual installation instructions

* Clone the Git Repository
* Copy ```appbox.rb``` from ```templates/plugins``` to ```yourinstallationdir/plugins```
* Copy ```appbox.css``` from ```templates/css``` to ```yourinstallationdir/source/stylesheets```
* Add the following line of HTML code to ```yourinstallationdir/source/_includes/custom/head.html```

```html
<link href="{{ root_url }}/stylesheets/appbox.css" media="screen, projection" rel="stylesheet" type="text/css">
```

If your theme and HTML files differ from the standard Octopress theme, modify the include for CSS to your use.

## Usage of AppBox Octopress

You can embed the AppBox in your posts with a shortcode:

```
{% appbox STORENAME APPID %}
```

If you want to take screenshots of the app in your appbox you have to modify the shortcode:

```
{% appbox STORENAME screenshots APPID %}
```

### Variables for STORENAME

You can use ```appstore``` for Apple AppStore or ```googleplay``` for the Google PlayStore

### How to get the APPID from Apple Appstore

When you open an url from Apples Appstore like:

```
https://itunes.apple.com/de/app/tweetbot-for-twitter/id557168941
```

The ID is the numerical string at the end of the url.

```
557168941
```

Make sure that you use it without the string ```id```.

### How to get the APPID from Google PlayStore

When you open or search an app on Goole PlayStore like

```
https://play.google.com/store/apps/details?id=com.twitter.android
```

the APPID is marked by the label ```id=``` in the url.

```
com.twitter.android
```

## More informations

In my blog I've written the full story of the way writing this plugin. You can check it out at http://sots.name/blog/2013/11/05/appbox-octopress-a-plugin-for-octopress-slash-jekyll-to-display-apps-more-smart-in-your-post/

Special thanks to [Marcel Schmilgeit](http://www.blogtogo.de). He wrote an AppBox Plugin for Wordpress based blogs. It was the inspiration for me to write this plugin for Octopress and Jekyll based sites.
