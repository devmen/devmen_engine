mySettings = {
  nameSpace:           "textile", // Useful to prevent multi-instances CSS conflict
  previewParserPath:   "/admin/preview.textile",
  onShiftEnter:        {keepDefault:false, replaceWith:'\n\n'},
  markupSet: [
    {name:'Heading 2', className:'mkitup-h2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Введите текст... (после заголовка оставьте пустую строку)' },
    {name:'Heading 3', className:'mkitup-h3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Введите текст... (после заголовка оставьте пустую строку)' },
    {name:'Paragraph', className:'mkitup-p', key:'P', openWith:'p(!(([![Class]!]))!). '}, 
    {separator:'---------------' },
    {name:'Bold', className:'mkitup-b', key:'B', closeWith:'*', openWith:'*'}, 
    {name:'Italic', className:'mkitup-i', key:'I', closeWith:'_', openWith:'_'}, 
    {name:'Stroke through', className:'mkitup-stroke', key:'S', closeWith:'-', openWith:'-'}, 
    {separator:'---------------' },
    {name:'Bulleted list', className:'mkitup-ul', openWith:'(!(* |!|*)!)'}, 
    {name:'Numeric list', className:'mkitup-ol', openWith:'(!(# |!|#)!)'}, 
    {separator:'---------------' },
    {name:'Link', className:'mkitup-a', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Текст для ссылки...' },
    {name:'Picture', className:'mkitup-img', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'},
    {separator:'---------------' },
    {name:'Images', className:'mkitup-images'},
    {name:'Files', className:'mkitup-files'},
    {separator:'---------------' },
    {name:'Quotes', className:'mkitup-quotes', openWith:'bq(!(([![Class]!]))!). '}, 
    {name:'Code', className:'mkitup-code', openWith:'@', closeWith:'@'}, 
    // {separator:'---------------' },       
    // {name:'Preview', className:'preview', call:'preview'}
  ]
}