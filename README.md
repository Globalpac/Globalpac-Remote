# Globalpac Remote

Cliente Windows do [RustDesk](https://github.com/rustdesk/rustdesk) 1.5.0 com a marca Globalpac. O rodapé diz **Desenvolvido por Globalpac**. A licença do cliente é a [AGPL-3.0](https://github.com/rustdesk/rustdesk/blob/1.5.0/LICENCE).

Este repositório não copia o código do RustDesk. O GitHub Actions baixa a tag `1.5.0`, aplica `brand/apply.ps1` e compila o `.exe`.

O que a marca muda:

- nome na janela e no instalador: RustDesk-Globalpac (o instalador do Windows não aceita espaço no nome)
- ícone e logo do site
- servidor gravado: `rustdesk.globalpac.com.br`
- chave pública do nosso hbbs

O pacote interno continua a chamar-se `rustdesk.exe`. Na instalação ele é renomeado para `RustDesk-Globalpac.exe`, que é o arquivo do atalho. O Suporte instala em `C:\Program Files\RustDesk-Globalpac-Suporte` e permanece só com ID e senha. Não há certificado de assinatura, por isso o Windows SmartScreen avisa na primeira execução.

## Compilar

O fluxo [Cliente Windows Globalpac](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/windows.yml) corre em cada push na `main` e também pode ser disparado à mão. Quando os `.exe` ficam prontos, o fluxo [Publicar release](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/release.yml) publica a versão definida na variável `VERSION` dos workflows `windows.yml` e `release.yml`. A 1.5.1 é a primeira em que o programa instalado busca a release deste repositório e se substitui. A 1.5.2 troca o rodapé para Desenvolvido por Globalpac. A 1.5.3 troca o ícone e a logo pelo quadrado azul com as duas setas brancas. A 1.5.4 desliga conta, agenda e dispositivos (já definida nos workflows; a última release publicada é a 1.5.3). A 1.5.0 continua publicada e não recebe esse aviso.

- `Globalpac-Suporte-{versão}-x86_64.exe` é o do cliente externo. Abre o ID e a senha de uso único, no estilo QuickSupport. Não deixa ligar a outros computadores.
- `Globalpac-{versão}-x86_64.exe` é o cliente completo, para a equipe.

O fluxo [Aviso RustDesk oficial](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/upstream.yml) compara a release de `rustdesk/rustdesk` com `RUSTDESK_REF`. Se a oficial for maior, abre uma issue. Não altera a base nem compila.

A compilação usa o runner do GitHub. Este PC não precisa de Rust, Flutter nem Visual Studio.
