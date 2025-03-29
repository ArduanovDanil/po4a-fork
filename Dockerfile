FROM ubuntu:latest

# Install Debian dependencies
RUN apt update
RUN apt install -y liblocale-gettext-perl libtext-wrapi18n-perl libunicode-linebreak-perl libpod-parser-perl libtest-pod-perl libyaml-tiny-perl libsyntax-keyword-try-perl
RUN apt install -y cpanminus gettext docbook-xml docbook-xsl docbook xsltproc
RUN apt install -y texlive-binaries texlive-latex-base opensp libsgmls-perl

ADD . ./po4a

WORKDIR /po4a

# Install CPAN dependencies
RUN cpanm Locale::gettext
RUN cpanm http://search.cpan.org/CPAN/authors/id/R/RA/RAAB/SGMLSpm-1.1.tar.gz
RUN cpanm Text::WrapI18N
RUN cpanm Unicode::GCString
RUN cpanm -v --installdeps --notest .

#Build po4a
RUN perl Build.PL
RUN COLUMNS=120 ./Build verbose=1
RUN ./Build install
RUN po4a --version

WORKDIR /src

ENTRYPOINT [ "po4a" ]
