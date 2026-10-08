# Globalpac Remote

Cliente Windows do [RustDesk](https://github.com/rustdesk/rustdesk) 1.5.0 com a marca Globalpac. O programa continua a dizer **Powered by RustDesk**. A licença do cliente é a [AGPL-3.0](https://github.com/rustdesk/rustdesk/blob/1.5.0/LICENCE).

Este repositório não copia o código do RustDesk. O GitHub Actions baixa a tag `1.5.0`, aplica `brand/apply.ps1` e compila o `.exe`.

O que a marca muda:

- nome na janela e no instalador: Globalpac
- ícone e logo do site
- servidor gravado: `rustdesk.globalpac.com.br`
- chave pública do nosso hbbs

O ficheiro interno continua a chamar-se `rustdesk.exe`. Não há certificado de assinatura, por isso o Windows SmartScreen avisa na primeira execução.

## Compilar

O fluxo [Cliente Windows Globalpac](../../actions/workflows/windows.yml) corre em cada push na `main` e também pode ser disparado à mão. O artefacto é `Globalpac-1.5.0-x86_64.exe`.

A compilação usa o runner do GitHub. Este PC não precisa de Rust, Flutter nem Visual Studio.
