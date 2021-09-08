> 提醒： 滥用可能导致账户被BAN！！！   

* 使用[v2ray](https://github.com/v2fly/v2ray-core)+caddy同时部署通过ws传输的vmess vless trojan shadowsocks socks等协议  
* 支持tor网络，且可通过自定义网络配置文件启动xray和caddy来按需配置各种功能  
* 支持存储自定义文件,目录及账号密码均为AUUID,客户端务必使用TLS连接 
* ![捕获1](https://user-images.githubusercontent.com/72486732/132502802-37d11f41-e9ee-4041-821b-e1fc2bfd0c29.PNG) Fork本项目后将readme.md中的mixool替换为自己的用户名后再进行部署，非常重要，切记！！！！
* 部署时出现We couldn't deploy your app because the source code violates the Salesforce Acceptable Use and External-Facing Services Policy提示时请更改项目名后再重新尝试部署。
  
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/mixool/xrayku)  
  
### 服务端
点击上面紫色`Deploy to Heroku`，会跳转到heroku app创建页面，填上app的名字、选择节点、按需修改部分参数和AUUID后点击下面deploy创建app即可开始部署  
如出现错误，可以多尝试几次，待部署完成后页面底部会显示Your app was successfully deployed  
  * 点击Manage App可在Settings下的Config Vars项**查看和重新设置参数**  
  * 点击Open app跳转[欢迎页面](/etc/CADDYIndexPage.md)域名即为heroku分配域名，格式为`appname.herokuapp.com`，用于客户端  
  * 默认协议密码为$UUID，WS路径为/$UUID-[vmess|vless]格式
  * 由于xray-core已经更换为v2ray-core，不再部署torjan-go/ss，有能力的可以推pr
  
### 客户端
* **务必替换所有的appname.herokuapp.com为heroku分配的项目域名**  
* **务必替换所有的8f91b6a0-e8ee-11ea-adc1-0242ac120002为部署时设置的AUUID**  
  
<details>
<summary>xray</summary>

```bash
* 客户端下载：https://github.com/XTLS/Xray-core/releases
* 代理协议：vless 或 vmess
* 地址：appname.herokuapp.com
* 端口：443
* 默认UUID：8f91b6a0-e8ee-11ea-adc1-0242ac120002
* 加密：none
* 传输协议：ws
* 伪装类型：none
* 路径：/8f91b6a0-e8ee-11ea-adc1-0242ac120002-vless // 默认vless使用/$uuid-vless，vmess使用/$uuid-vmess
* 底层传输安全：tls
```
</details>

<details>
<summary>cloudflare workers example</summary>

```js
const SingleDay = 'appname.herokuapp.com'
const DoubleDay = 'appname.herokuapp.com'
addEventListener(
    "fetch",event => {
    
        let nd = new Date();
        if (nd.getDate()%2) {
            host = SingleDay
        } else {
            host = DoubleDay
        }
        
        let url=new URL(event.request.url);
        url.hostname=host;
        let request=new Request(url,event.request);
        event. respondWith(
            fetch(request)
        )
    }
)
```
</details>
  
> [更多来自热心网友PR的使用教程](/tutorial)
