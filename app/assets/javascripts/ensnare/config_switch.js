// Config switcher
function config_switch (config_type){
  config_array = ["log_only", "time_throttle","light","medium","heavy","custom"];
  for (var i=0,len=config_array.length; i<len; i++){
    $('#' + config_array[i]).addClass('hidden');
    $('#' + config_array[i] + "_nav").removeClass('active');
  }
function capitaliseFirstLetter(string)
{
    var capital =  string.charAt(0).toUpperCase() + string.slice(1);
    return capital.replace(/\_/, ' ');
}

// This
$('#copy-button').attr('data-clipboard-target', config_type + '_config');
$('#' + config_type).removeClass('hidden');
$('#' + config_type + "_nav").addClass('active');
document.getElementById("config_name").innerHTML = capitaliseFirstLetter(config_type);
}
