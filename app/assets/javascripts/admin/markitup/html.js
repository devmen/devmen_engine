mySettings = {
  nameSpace:          "html", // Useful to prevent multi-instances CSS conflict
  previewParserPath:  "/admin/preview.html",
  onShiftEnter: {keepDefault:false, replaceWith:'<br />\n'},
  onCtrlEnter:  {keepDefault:false, openWith:'\n<p>', closeWith:'</p>\n'},
  onTab:        {keepDefault:false, openWith:'   '},
  markupSet: [    
    {name:'Heading 2', className:'mkitup-h2', key:'2', openWith:'<h2(!( class="[![Class]!]")!)>', closeWith:'</h2>', placeHolder:'Your title here...' },
    {name:'Heading 3', className:'mkitup-h2', key:'3', openWith:'<h3(!( class="[![Class]!]")!)>', closeWith:'</h3>', placeHolder:'Your title here...' },    
    {name:'Paragraph', className:'mkitup-p', openWith:'<p(!( class="[![Class]!]")!)>', closeWith:'</p>' },
    {separator:'---------------' },
    {name:'Bold', className:'mkitup-b', key:'B', openWith:'(!(<strong>|!|<b>)!)', closeWith:'(!(</strong>|!|</b>)!)' },
    {name:'Italic', className:'mkitup-i', key:'I', openWith:'(!(<em>|!|<i>)!)', closeWith:'(!(</em>|!|</i>)!)' },
    {name:'Stroke through', className:'mkitup-stroke', key:'S', openWith:'<del>', closeWith:'</del>' },
    {separator:'---------------' },
    {name:'Ul', className:'mkitup-ul', openWith:'<ul>\n', closeWith:'</ul>\n' },
    {name:'Ol', className:'mkitup-ol', openWith:'<ol>\n', closeWith:'</ol>\n' },
    {name:'Li', className:'mkitup-li', openWith:'<li>', closeWith:'</li>' },
    {separator:'---------------' },
    {name:'Link', className:'mkitup-a', key:'L', openWith:'<a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)>', closeWith:'</a>', placeHolder:'Your text to link...' },
    {name:'Picture', className:'mkitup-img', key:'P', replaceWith:'<img src="[![Source:!:http://]!]" alt="[![Alternative text]!]" />' },    
    {separator:'---------------' },
    {name:'Images', className:'mkitup-images'},
    {name:'Files', className:'mkitup-files'},    
    // {separator:'---------------' },    
    // {name:'Preview', className:'preview', call:'preview' }
  ]
}