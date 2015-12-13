default['php-fpm']['user'] = 'www-data'
default['php-fpm']['group'] = 'www-data'
default['php-fpm']['log_level'] = 'notice'
default['php-fpm']['emergency_restart_threshold'] = 0
default['php-fpm']['emergency_restart_interval'] = 0
default['php-fpm']['process_control_timeout'] = 0
default['php-fpm']['pools'] = {
  'www' => {
    enable: true,
    php_options: {
      'php_value[memory_limit]' => '128M',
      'php_value[max_execution_time]' => '240',
      'php_value[variables_order]' => 'EGPCS',
      'php_value[post_max_size]' => '32M',
      'php_value[upload_max_filesize]' => '32M',
      'php_value[date.timezone]' => 'Europe/Berlin',
      'php_value[xdebug.max_nesting_level]' => 400,
      'php_value[max_input_vars]' => 2000,
      'php_value[apc.shm_size]' => '128M',
      'php_value[apc.entries_hint]' => '16384',
      'php_value[apc.rfc1867]' => '1',
      'php_value[always_populate_raw_post_data]' => '-1',
    }
  }
}
