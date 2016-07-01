default['tz'] = 'Europe/Berlin'

default['system']['extra_packages'] = %w(curl ghostscript git graphicsmagick gsfonts imagemagick poppler-utils postfix unzip vim wget zip)

default['locales']['locale_file'] = '/etc/locale.gen'
default['locales']['packages'] = %w(language-pack-de language-pack-en language-pack-fr language-pack-nl)
default['locales']['available_locales'] = %w(de_DE.UTF-8 en_US.UTF-8 en_GB.UTF-8 fr_FR.UTF-8 nl_NL.UTF-8)

default['system']['ssh_known_hosts'] = [
    'git.typo3.org',
    'github.com',
    'packagist.org',
    '-p 29418 review.typo3.org'
]
