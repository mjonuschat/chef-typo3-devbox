default['tz'] = 'Europe/Berlin'

default['system']['extra_packages'] = [
  'curl',
  'ghostscript',
  'git',
  'graphicsmagick',
  'gsfonts',
  'imagemagick',
  'poppler-utils',
  'postfix',
  'unzip',
  'vim',
  'wget',
  'zip'
]

default['system']['available_locales'] = [
  'de_DE.UTF-8',
  'en_US.UTF-8',
  'en_GB.UTF-8',
  'fr_FR.UTF-8',
  'nl_NL.UTF-8'
]

default['system']['ssh_known_hosts'] = [
  'git.typo3.org',
  'github.com',
  'packagist.org',
  '-p 29418 review.typo3.org'
]
