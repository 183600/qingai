require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.DialogInterface"
状态栏高度=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height)
颜色1="#ff000000"
强调色="#ff1772b4"
import "layout"
import "http"
--导入
JSON=import "json"
activity.setTheme(android.R.style.Theme_DeviceDefault_Light)
activity.setContentView(loadlayout(layout))
activity.ActionBar.Elevation=0
数据路径="/data/data/"..activity.getPackageName()
当前模型显示给用户的名称="DeepSeek-R1-Distill-Qwen-7B"
当前模型api中的名称="deepseek-ai/DeepSeek-R1-Distill-Qwen-7B"
activity.ActionBar.setTitle("轻AI(当前"..当前模型显示给用户的名称..")")
模型列表={
  {api中的名称="deepseek-ai/DeepSeek-R1-Distill-Llama-8B",显示给用户的名称="DeepSeek-R1-Distill-Llama-8B"},
  {api中的名称="deepseek-ai/DeepSeek-R1-Distill-Qwen-7B",显示给用户的名称="DeepSeek-R1-Distill-Qwen-7B"},
  {api中的名称="deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B",显示给用户的名称="DeepSeek-R1-Distill-Qwen-1.5B"},
  {api中的名称="Qwen/Qwen2.5-7B-Instruct",显示给用户的名称="Qwen2.5-7B-Instruct"},
  {api中的名称="Qwen/Qwen2.5-Coder-7B-Instruct",显示给用户的名称="Qwen2.5-Coder-7B-Instruct"},
  {api中的名称="internlm/internlm2_5-7b-chat",显示给用户的名称="internlm2_5-7b-chat"},
}
function 长按(v)
  if v==对话历史TextView then
    显示的字符串=v.Text
   else
    显示的字符串=v.Tag.text.Text
  end
  长按菜单项列表={"全部复制","选择复制","分享"}
  --列表的
  AlertDialog.Builder(this)
  .setItems(长按菜单项列表,function(_,b)
    if 长按菜单项列表[b+1]=="全部复制" then
      --先导入包
      import "android.content.*"
      activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(显示的字符串)
     elseif 长按菜单项列表[b+1]=="选择复制" then
      选择复制布局={
        ScrollView;
        layout_width='fill';--布局宽度
        layout_height='fill';--布局高度
        {
          LinearLayout,
          orientation="vertical",
          layout_width="fill",
          layout_height="fill",
          padding='18dp';
          {
            TextView;
            -- layout_width='wrap';
            layout_height='fill';
            --Gravity='left|center';
            textColor=颜色1;
            BackgroundColor="#00000000";
            text=显示的字符串;
            id="AI发送过来的消息TextView",
            textSize='16.9sp';
            textIsSelectable=true
          }
        }
      }
      --带有三个按钮的对话框
      AlertDialog.Builder(this)
      .show()
      .getWindow().setContentView(loadlayout(选择复制布局));
     elseif 长按菜单项列表[b+1]=="分享" then
      --分享文字
      text=显示的字符串
      intent=Intent(Intent.ACTION_SEND);
      intent.setType("text/plain");
      intent.putExtra(Intent.EXTRA_SUBJECT, "分享");
      intent.putExtra(Intent.EXTRA_TEXT, text);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      activity.startActivity(Intent.createChooser(intent,"分享到:"));
    end
  end)
  .show();
end
local item=
{
  FrameLayout,
  layout_width="fill",
  --layout_height='56dp';
  --layout_marginRight='52dp';
  --[[{
      ImageView;
      --src=图标;
      layout_width='24dp';
      layout_height='24dp';
      layout_gravity='left|center';
      layout_marginLeft='36dp';
      id='Image2';
      ColorFilter=文字;--设置图片着色
      Alpha=0.8,
    };]]
  {
    EditText;
    -- layout_width='wrap';
    layout_height='fill';
    layout_marginLeft='18dp';
    Gravity='left|center';
    textColor=颜色1;
    BackgroundColor="#00000000";
    hint='给AI发送消息';
    id="给AI发送的消息EditText",
    textSize='21sp';
    MaxLines=1;--设置最大输入行数
  };
  {
    TextView;
    -- layout_width='wrap';
    layout_height='fill';
    layout_marginLeft='18dp';
    Gravity='left|center';
    textColor=颜色1;
    BackgroundColor="#00000000";
    id="给AI发送的消息TextView",
    textSize='21sp';
    --textIsSelectable=true
  };
};
local item2=
{
  FrameLayout,
  layout_width="fill",
  --layout_height='56dp';
  --layout_marginRight='52dp';
  --[[{
      ImageView;
      --src=图标;
      layout_width='24dp';
      layout_height='24dp';
      layout_gravity='left|center';
      layout_marginLeft='36dp';
      id='Image2';
      ColorFilter=文字;--设置图片着色
      Alpha=0.8,
    };]]
  {
    TextView;
    -- layout_width='wrap';
    layout_height='fill';
    layout_marginLeft='18dp';
    layout_marginRight='18dp';
    layout_marginBottom='18dp';
    --Gravity='left|center';
    textColor=颜色1;
    BackgroundColor="#00000000";
    text='正在回答...';
    id="AI发送过来的消息TextView",
    textSize='16.9sp';
    --textIsSelectable=true
  };
};
import "java.io.File"
function 写入文件(路径,内容)
  f=File(tostring(File(tostring(路径)).getParentFile())).mkdirs()
  io.open(tostring(路径),"w"):write(tostring(内容)):close()
end
function 文件是否存在(id)
  return File(id).exists()
end
if not 文件是否存在(数据路径.."/对话历史.json") then
  写入文件(数据路径.."/对话历史.json",JSON.encode({}))
end
对话历史=JSON.decode(io.open(数据路径.."/对话历史.json"):read("*a"))
for i=1,#对话历史 do
  if 对话历史[i].发送给AI的消息 then
    if 对话历史[i].发送给AI的消息=="" then
     else
      对话历史TextView.text=对话历史TextView.text.."\n\n"..对话历史[i].发送给AI的消息..":"
    end
   elseif 对话历史[i].AI输出的消息 then
    对话历史TextView.text=对话历史TextView.text.."\n"..对话历史[i].AI输出的消息
  end
end
--print(dump(对话历史))
对话历史TextView.onLongClick=长按;
背景LinearLayout.addView(loadlayout(item))

function 设置给AI发送的消息EditText的事件(给AI发送的消息EditText2)
  给AI发送的消息EditText2.onKey=function(_,b)
    --控件隐藏
    给AI发送的消息EditText2.setVisibility(View.GONE)
    给AI发送的消息TextView.text=给AI发送的消息EditText2.text
    背景LinearLayout.addView(loadlayout(item2))
    table.insert(对话历史,{是否是给AI发送的消息=true,发送给AI的消息=给AI发送的消息TextView.text})
    写入文件(数据路径.."/对话历史.json",JSON.encode(对话历史))
    Http.post("https://api.siliconflow.cn/v1/chat/completions",[[{
  "model": "]]..当前模型api中的名称..[[",
  "messages": [
    {
      "role": "user",
      "content": "]]..给AI发送的消息TextView.text..[["
    }
  ],
  "stream": false,
  "max_tokens": 512,
  "stop": [
    "null"
  ],
  "temperature": 0.7,
  "top_p": 0.7,
  "top_k": 50,
  "frequency_penalty": 0.5,
  "n": 1,
  "response_format": {
    "type": "text"
  }
}]],"utf8",{["Authorization"]="Bearer sk-sieqwktkdspwgkbibsygcopuyxgmqgobixrxnjodsowpbggi",
    ["Content-Type"]="application/json"},function(body,cookie,code,headers)
      --print(body,1111,cookie,2222,code,3333,headers,4444,dump(headers))
      --解析json
      json_o=JSON.decode(cookie)
      --print(5555,dump(json_o))
      AI发送过来的消息TextView.text=(json_o.choices[1].message.content or "")..(json_o.choices[1].message.reasoning_content or "")
      背景LinearLayout.addView(loadlayout(item))
      设置给AI发送的消息EditText的事件(给AI发送的消息EditText)
      table.insert(对话历史,{是否是给AI发送的消息=false,AI输出的消息=AI发送过来的消息TextView.text})
      写入文件(数据路径.."/对话历史.json",JSON.encode(对话历史))
    end)
  end
end
设置给AI发送的消息EditText的事件(给AI发送的消息EditText)

--菜单
function onCreateOptionsMenu(menu)
  menu.add("选择模型")
    menu.add("统计")
menu.add("关于")
  menu.add("退出")
end
function onOptionsItemSelected(item)
  if item.Title=="选择模型" then
    模型显示给用户的名称列表={}
    for i=1,#模型列表 do
      table.insert(模型显示给用户的名称列表,模型列表[i].显示给用户的名称)
    end
    --列表的
    AlertDialog.Builder(this)
    .setTitle("选择模型(当前"..当前模型显示给用户的名称..")")
    .setItems(模型显示给用户的名称列表,function(_,b)
      当前模型api中的名称=模型列表[b+1].api中的名称
      当前模型显示给用户的名称=模型列表[b+1].显示给用户的名称
      activity.ActionBar.setTitle("轻AI(当前"..当前模型显示给用户的名称..")")
    end)
    .show();
   elseif item.Title=="关于" then
    --带有三个按钮的对话框
    AlertDialog.Builder(this)
    .setTitle("关于")
    .setMessage("开发者183600(qwe12345678)\n开发者github地址https://github.com/183600\n本软件使用AndroLua+开发")
    .setPositiveButton("确定",nil)
    .show();
   elseif item.Title=="统计" then
    对话历史=JSON.decode(io.open(数据路径.."/对话历史.json"):read("*a"))
    发送给AI的消息总字数=0
    AI输出的消息总字数=0
    AI输出的消息数量=0
    for i=1,#对话历史 do
      if 对话历史[i].发送给AI的消息 then
        if 对话历史[i].发送给AI的消息=="" then
         else
          发送给AI的消息总字数=发送给AI的消息总字数+#(对话历史[i].发送给AI的消息)
        end
      end
      if 对话历史[i].AI输出的消息 then
        if 对话历史[i].发送给AI的消息=="" then
         else
          AI输出的消息总字数=AI输出的消息总字数+#(对话历史[i].AI输出的消息)
          AI输出的消息数量=AI输出的消息数量+1
        end
      end
    end
    --带有三个按钮的对话框
    AlertDialog.Builder(this)
    .setTitle("统计")
    .setMessage("不能确保结果准\n发送给AI的消息总字数"..发送给AI的消息总字数.."\nAI输出的消息总字数"..AI输出的消息总字数.."\nAI输出的消息数量"..AI输出的消息数量.."\nAI输出的消息平均每个字数"..tostring(tonumber(AI输出的消息总字数/AI输出的消息数量)))
    .setPositiveButton("确定",nil)
    .show();
   elseif item.Title=="退出" then
    activity.finish()
      end
end
-- 延迟执行确保布局完成
背景ScrollView.post(function()
  -- 方法1：使用 fullScroll 自动滚动
  背景ScrollView.fullScroll(1)

  -- 方法2：手动计算滚动位置
  -- local contentHeight = linearLayout.getHeight()
  -- local viewportHeight = scrollView.getHeight()
  -- if contentHeight > viewportHeight then
  --     scrollView.scrollTo(0, contentHeight - viewportHeight)
  -- end
end)