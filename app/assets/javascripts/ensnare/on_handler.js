// Make sure the log_only config is displayed and ready to copy on initial load
window.onload = function() {config_switch('log_only');};

document.getElementById('log_only_nav').onclick = function() {config_switch('log_only');};
document.getElementById('time_throttle_nav').onclick = function() {config_switch('time_throttle');};
document.getElementById('light_nav').onclick = function() {config_switch('light');};
document.getElementById('medium_nav').onclick = function() {config_switch('medium');};
document.getElementById('heavy_nav').onclick = function() {config_switch('heavy');};
document.getElementById('custom_nav').onclick = function() {config_switch('custom');};
