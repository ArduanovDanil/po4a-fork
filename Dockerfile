FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8

# Копируем файлы проекта в контейнер
COPY . /app

# Переходим в каталог с файлами проекта
WORKDIR /app

RUN apt update
RUN apt install -y liblocale-gettext-perl libtext-wrapi18n-perl libunicode-linebreak-perl libpod-parser-perl libtest-pod-perl libyaml-tiny-perl libsyntax-keyword-try-perl
RUN apt install -y cpanminus gettext docbook-xml docbook-xsl docbook xsltproc 
RUN apt install -y texlive-binaries texlive-latex-base opensp libsgmls-perl

# install package requirements for po4a
#RUN apt-get install -qy gettext liblocale-gettext-perl xsltproc

# install the pre-requisites for po4a
RUN cpanm Locale::gettext
RUN cpanm http://search.cpan.org/CPAN/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz
RUN cpanm Text::WrapI18N
RUN cpanm Unicode::GCString
RUN cpanm -v --installdeps --notest .

# cachebuster value is the latest commit to github for po4a
# you can update this to force a rebuild of the image
#RUN git clone https://github.com/mquinson/po4a.git

# build po4a
RUN perl Build.PL
RUN ./Build; exit 0
RUN ./Build install

ENTRYPOINT ["tail", "-f", "/dev/null"]