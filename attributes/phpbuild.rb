default['phpbuild']['repository'] = 'git://github.com/php-build/php-build.git'
default['phpbuild']['revision'] = 'master'
default['phpbuild']['installdir'] = '/usr/local/phpbuild'
default['phpbuild']['installdir_php'] = '/opt/php'
default['phpbuild']['packages'] = [
  'libbz2-dev',
  'libc-client2007e-dev',
  'libcurl4-openssl-dev',
  'libfreetype6-dev',
  'libgd-dev',
  'libgmp3-dev',
  'libgnutls28-dev',
  'libicu-dev',
  'libjpeg-dev',
  'libkrb5-dev',
  'libldap2-dev',
  'libmagic-dev',
  'libmcrypt-dev',
  'libpng12-dev',
  'libpq-dev',
  'libpspell-dev',
  'libreadline-dev',
  'librecode-dev',
  'libsqlite3-dev',
  'libssl-dev',
  'libtidy-dev',
  'libxml2-dev',
  'libxslt1-dev',
  'pkg-config',
  'tzdata',
  'zlib1g-dev',
]
default['phpbuild']['versions'] = {
#  '5.3' => {
#    version: '5.3.29',
#    options: '--with-freetype-dir=/usr --with-bz2 --with-imap=/usr --with-imap-ssl --with-pspell --with-libdir=lib',
#    extensions: 'apcu=4.0.10 igbinary=1.2.1',
#  },
#  '5.4' => {
#    version: '5.4.45',
#    options: '--with-freetype-dir=/usr --with-bz2 --with-imap=/usr --with-imap-ssl --enable-intl --with-pspell --with-libdir=lib',
#    extensions: 'apcu=4.0.10 igbinary=1.2.1',
#  },
  '5.5' => {
    version: '5.5.34',
    options: '--with-freetype-dir=/usr --with-bz2 --with-imap=/usr --with-imap-ssl --enable-intl --with-pspell --with-libdir=lib',
    extensions: 'apcu=4.0.10',
  },
  '5.6' => {
    version: '5.6.20',
    options: '--with-freetype-dir=/usr --with-bz2 --with-imap=/usr --with-imap-ssl --enable-intl --with-pspell --with-libdir=lib',
    extensions: 'apcu=4.0.10',
    default: true,
  },
  '7.0' => {
    version: '7.0.5',
    options: '--with-freetype-dir=/usr --with-bz2 --with-imap=/usr --with-imap-ssl --enable-intl --with-pspell --with-libdir=lib',
    extensions: 'apcu=5.1.3'
  }
}
