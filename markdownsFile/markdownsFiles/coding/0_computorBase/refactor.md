# 目录

# 重构

教程：  https://www.bilibili.com/video/BV1mr4y1V7aD/?spm_id_from=333.788&vd_source=3eebd10b94a8a76eaf4b78bee8f23884

文档：https://hardcore.feishu.cn/docx/doxcn4HcvfoSVUvkLALvzfD4B5c





# 代码写法：差异性封装

目的、好处：

> 调用形式上统一（优雅，避免了if  else 逐个判断）
>
> 差异性，封装在一起，利于修改

手段：

> 差异化处理  《---------------》抽取公共部分

方法一：  **父类封装差异性**： **不同的差异，由不同的子类处理**

> 父类抽取公共部分，子类处理差异化：
>
> 例子：
>
> ```cpp
>  //解析init.rc时
>  ServiceParser::ParseLineSection   解析行时，根据不同的关键词，选择不同的SectionParser。比如：service 选择  ServiceParser；import 选择 ImportParser
> 
>  section_parser->ParseLineSection(std::move(args), state.line); // 【】section_parser 调用处，形式上统一
>  
>  
>    ---------->  TODO:  从设计角度来看：1、很合理：不同的类型，不同类来处理； 2、但是父类的抽象方法，是如何抽象出来的？
> ```

方法二： **map表封装差异性**（C语言常用的方法）:  **不同的差异，由不同的处理函数**

```cpp
 // \\system\\core\\init\\service_parser.cpp
 
 Result<void> ServiceParser::ParseLineSection(std::vector<std::string>&& args, int line) {
     if (!service_) {
         return {};
     }
 
     auto parser = GetParserMap().Find(args);
 
     if (!parser.ok()) return parser.error();
 
     return std::invoke(*parser, this, std::move(args)); // 【】调用处，形式上统一，看不出来差异
 }
 
 
 const KeywordMap<ServiceParser::OptionParser>& ServiceParser::GetParserMap() const {
     constexpr std::size_t kMax = std::numeric_limits<std::size_t>::max();
     static const KeywordMap<ServiceParser::OptionParser> parser_map = {   //  【】map封装差异性
         ...................
         {"group",                   {1,     NR_SVC_SUPP_GIDS + 1, &ServiceParser::ParseGroup}},
         ...................
         {"keycodes",                {1,     kMax, &ServiceParser::ParseKeycodes}},
         {"memcg.limit_in_bytes",    {1,     1,    &ServiceParser::ParseMemcgLimitInBytes}},
         {"memcg.limit_percent",     {1,     1,    &ServiceParser::ParseMemcgLimitPercent}},
         {"memcg.limit_property",    {1,     1,    &ServiceParser::ParseMemcgLimitProperty}},
         {"memcg.soft_limit_in_bytes",
         ..............................
         {"onrestart",               {1,     kMax, &ServiceParser::ParseOnrestart}},
         {"reboot_on_failure",       {1,     1,    &ServiceParser::ParseRebootOnFailure}},
         {"restart_period",          {1,     1,    &ServiceParser::ParseRestartPeriod}},
         {"rlimit",                  {3,     3,    &ServiceParser::ParseProcessRlimit}},
         ..............................
         {"sigstop",                 {0,     0,    &ServiceParser::ParseSigstop}},
         {"socket",                  {3,     6,    &ServiceParser::ParseSocket}},
         {"task_profiles",           {1,     kMax, &ServiceParser::ParseTaskProfiles}},
         {"timeout_period",          {1,     1,    &ServiceParser::ParseTimeoutPeriod}},
         {"user",                    {1,     1,    &ServiceParser::ParseUser}},
     };
     // clang-format on
     return parser_map;
 }
```

