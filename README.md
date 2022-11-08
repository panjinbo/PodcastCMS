# Podcast CMS
PodcastCMS是一款由Swift UI编写的Mac App，是基于AWS S3/AWS Cloudfront作为后端的创建/管理/分布播客的Mac客户端。

## 背景
自己很喜欢收听播客，但是由于各种平台版权的问题，不同的播客节目需要用不同的App来收听，而且节目很容易被下架。
Apple Podcast App提供了很多节目资源，而且还可以通过RSS源来添加自定义的节目。所以想通过这个App来提供统一收听播客的体验。
收听播客的客户端有了，还需要一个好的方法来创建/管理/分布自己的播客内容。虽然市场上有很多这样的服务，但是普遍大公司的收费比较贵，小公司又害怕不稳定倒闭，所以准备将内容放在AWS S3存储，用AWS Cloudfront来做发布。
而这款软件则是用来在本地将音频文件上传到AWS S3，同时创建RSS源用与Apple Podcast。

## 使用方法
(待加入)

## 附加
[AWS S3价格](https://aws.amazon.com/cn/s3/pricing/)

[AWS Cloudfront价格](https://aws.amazon.com/cn/cloudfront/pricing/)

[Apple Podcast RSS标准](https://help.apple.com/itc/podcasts_connect/#/itcb54353390)

## Licenses
GPLv3
