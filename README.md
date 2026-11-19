# Globalpac Remote

O **Globalpac-Suporte** é o programa de acesso remoto da Globalpac para o atendimento técnico. Basta instalar, abrir o programa e enviar o ID e a senha para o suporte.

## Como baixar e usar

> **Importante!**
> A instalação deve ser feita em um computador com **Windows 10 ou superior**.
> Em servidores, é compatível com o **Windows Server 2019 ou superior**.

### Instalação

**1.** Baixe o instalador na [página da última versão](https://github.com/Globalpac/Globalpac-Remote/releases/latest). Use o arquivo que começa com **Globalpac-Suporte** e termina com **x86_64.exe**. O número no nome muda a cada versão. Não use o arquivo que se chama só `Globalpac-...exe` — esse é o cliente da equipe.

**2.** Execute o arquivo baixado.

**3.** Se o Windows mostrar o aviso do SmartScreen (“O Windows protegeu o seu computador”), clique em **Mais informações** e depois em **Executar assim mesmo**. Isso acontece porque o programa ainda não tem certificado de assinatura.

**4.** Clique em **Next**.

**5.** Aceite os termos e clique em **Next**.

**6.** **Diretório de instalação:**

Por padrão, o diretório é: **C:\Program Files\RustDesk-Globalpac-Suporte**.

Recomendamos que o local de instalação não seja alterado. Apenas clique em **Next**.

Caso deseje alterar o local, clique em **Change…** e selecione uma nova pasta.

Após definir o diretório, clique em **Next**.

**7.** Clique em **Install** para iniciar a instalação.

Sucesso! O Globalpac-Suporte está pronto para ser utilizado.

### Como passar o ID e a senha ao suporte

**1.** Abra o **Globalpac-Suporte**.

**2.** Na tela principal aparecem o **ID** e a **senha** de uso único.

**3.** Envie os dois para o suporte da Globalpac. Não compartilhe com outras pessoas.

**4.** Aguarde o atendimento se conectar. Não feche o programa enquanto o suporte estiver em andamento.

O Globalpac-Suporte serve só para receber o atendimento. Ele não conecta a outros computadores.

## Para a equipe

Cliente Windows do [RustDesk](https://github.com/rustdesk/rustdesk) 1.5.0 com a marca Globalpac. O rodapé diz **Desenvolvido por Globalpac**. A licença do cliente é a [AGPL-3.0](https://github.com/rustdesk/rustdesk/blob/1.5.0/LICENCE).

Este repositório não copia o código do RustDesk. O GitHub Actions baixa a tag `1.5.0`, aplica `brand/apply.ps1` e compila o `.exe`.

O que a marca muda:

- nome na janela e no instalador: RustDesk-Globalpac (o instalador do Windows não aceita espaço no nome)
- ícone e logo do site
- servidor gravado: `rustdesk.globalpac.com.br`
- chave pública do nosso hbbs

O pacote interno ainda se chama `rustdesk.exe`. Na instalação ele é renomeado para `RustDesk-Globalpac.exe`, que é o arquivo do atalho. O Suporte instala em `C:\Program Files\RustDesk-Globalpac-Suporte` e permanece só com ID e senha. Não há certificado de assinatura, por isso o Windows SmartScreen avisa na primeira execução.

### Compilar

O fluxo [Cliente Windows Globalpac](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/windows.yml) roda em cada push na `main` e também pode ser disparado à mão. Quando os `.exe` ficam prontos, o fluxo [Publicar release](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/release.yml) publica a versão definida na variável `VERSION` dos workflows `windows.yml` e `release.yml`. A 1.5.1 é a primeira em que o programa instalado busca a release deste repositório e se substitui. A 1.5.2 troca o rodapé para Desenvolvido por Globalpac. A 1.5.3 troca o ícone e a logo pelo quadrado azul com as duas setas brancas. A 1.5.4 desliga conta, agenda e dispositivos. A última release publicada é a 1.5.4. A 1.5.0 continua publicada e não recebe esse aviso.

- `Globalpac-Suporte-{versão}-x86_64.exe` é o do cliente externo. Abre o ID e a senha de uso único, no estilo QuickSupport. Não deixa ligar a outros computadores.
- `Globalpac-{versão}-x86_64.exe` é o cliente completo, para a equipe.

O fluxo [Aviso RustDesk oficial](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/upstream.yml) compara a release de `rustdesk/rustdesk` com `RUSTDESK_REF`. Se a oficial for maior, abre uma issue. Não altera a base nem compila.

A compilação usa o runner do GitHub. Este PC não precisa de Rust, Flutter nem Visual Studio.
