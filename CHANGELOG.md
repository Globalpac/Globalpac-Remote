# Changelog

Versão do cliente Globalpac (a base do RustDesk continua na tag indicada no `NOTICE.md` e em `RUSTDESK_REF`). A versão publicada está em `env.VERSION` nos workflows `windows.yml` e `release.yml`, não num arquivo `VERSION`.

## 1.5.6

Acrescenta o artefato **Globalpac-Acesso** (acesso não assistido, senha permanente definida na instalação). Convive com o Suporte e com o cliente completo no mesmo PC.

## 1.5.5

O Suporte passa a ter nome próprio (`RustDesk-Globalpac-Suporte`) para conviver com o cliente completo, e ganha a versão portátil. Também publica cópias com nome fixo (`Globalpac-Suporte-Setup.exe`, `Globalpac-Suporte-Portatil.exe`) para o site.

## 1.5.4

Desliga conta, agenda e dispositivos no cliente instalado. Inclui a correção do retorno `null` em `Future<bool?>` no `login.dart`.

## 1.5.3

Troca o ícone e a logo pelo quadrado azul com as duas setas brancas.

## 1.5.2

Troca o rodapé para Desenvolvido por Globalpac. Atualiza o `Cargo.lock` junto com a versão da marca para o `cargo --locked` aceitar o build.

## 1.5.1

Primeira versão em que o programa instalado busca a release deste repositório e se substitui.

## 1.5.0

Primeira release publicada do cliente Windows da Globalpac, baseada no RustDesk 1.5.0.
