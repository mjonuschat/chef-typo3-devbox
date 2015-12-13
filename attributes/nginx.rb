default['nginx']['sites'] = {
  'master.local.typo3.org' => {
    'default_php_version' => '7.0',
    'document_root' => '/var/www/html/master.local.typo3.org',
    'install_redirect' => '/typo3/sysext/install/Start/Install.php',
  },
  'seven.local.typo3.org' => {
    'default_php_version' => '5.6',
    'document_root' => '/var/www/html/seven.local.typo3.org',
    'install_redirect' => '/typo3/sysext/install/Start/Install.php',
  },
  'six.local.typo3.org' => {
    'default_php_version' => '5.5',
    'document_root' => '/var/www/html/six.local.typo3.org',
    'install_redirect' => '/typo3/sysext/install/Start/Install.php',
  },
  'four.local.typo3.org' => {
    'default_php_version' => '5.5',
    'document_root' => '/var/www/html/four.local.typo3.org',
  },
}
