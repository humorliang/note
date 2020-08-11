## 前端获取响应头缺失问题
后端需要在header当中设置http响应头
```
ctx.Header("Content-Disposition", fmt.Sprintf("attachment; filename=%s", tmp.Name))
//自定义得响应头
ctx.Header("X-FileName", fmt.Sprintf("%s", tmp.Name))
//二进制数据流
ctx.Header("Content-Type", "application/octet-stream")
//设置需要导出得响应头 
ctx.Header("Access-Control-Expose-Headers", "Content-Disposition,X-FileName")
```