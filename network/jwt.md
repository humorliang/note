## JWT 认证方式
### 使用 JWT 的场景
- 身份验证 用户在登录过后服务器会用 jwt 返回用户可访问的资源,比如权限什么的
- 传递信息 通过 jwt 的header和signature可以保证payload没有被篡改,保证信息的安全
### JWT 的结构
JWT 是由header,payload,signature三部分组成的。
- header
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
// base64编码的字符串`eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`
这里规定了加密算法,hash256
```
- payload
```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true
}
// base64编码的字符串`eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9`
```
这里的内容没有强制要求,因为 paylaod 就是为了承载内容而存在的,不过想用规范的话也可以参考下面的
```js
* iss: jwt签发者
* sub: jwt所面向的用户
* aud: 接收jwt的一方
* exp: jwt的过期时间，这个过期时间必须要大于签发时间
* nbf: 定义在什么时间之前，该jwt都是不可用的.
* iat: jwt的签发时间
* jti: jwt的唯一身份标识，主要用来作为一次性token,从而回避重放攻击。
```
- signature
是用 header + payload + secret组合起来加密的,公式是:
```js
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  secret)
```
这里 secret就是自己定义的一个随机字符串,这一个过程只能发生在 server 端,会随机生成一个 hash 值

这样组合起来之后就是一个完整的 jwt 了:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.4c9540f793ab33b13670169bdf444c1eb1c37047f18e861981e14e34587b1e04
```
