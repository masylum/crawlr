/*
// unobstrusive javascript makes people happier
$(function(){
  
  // this is why jquery rocks
  $('a.milkit, a.reportit').live("click", function(){
    var url_str = $(this).attr('href');
    console.log(url_str);
    $.ajax({
        url: '/milk/4',
        dataType: 'html',
        data:{},
        beforeSend: function(xhr) {xhr.setRequestHeader('Accept', 'text/javascript');},
        success: function(data, status) {
          $('#galleries').html(data);
        }
    });
    return false;
  });  
});
*/