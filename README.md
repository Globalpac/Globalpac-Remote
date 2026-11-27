# Globalpac Remote

O **Globalpac-Suporte** é o programa de acesso remoto da Globalpac para o atendimento técnico. Você abre o programa e envia o ID e a senha para o suporte.

## Como baixar e usar

> **Importante!**
> Funciona em computadores com **Windows 10 ou superior**.
> Em servidores, funciona no **Windows Server 2019 ou superior**.

Há duas formas. Use uma delas:

- **[Baixar o instalador](https://github.com/Globalpac/Globalpac-Remote/releases/latest/download/Globalpac-Suporte-Setup.exe)** (`Globalpac-Suporte-Setup.exe`): fica instalado no computador.
- **[Baixar a versão portátil](https://github.com/Globalpac/Globalpac-Remote/releases/latest/download/Globalpac-Suporte-Portatil.exe)** (`Globalpac-Suporte-Portatil.exe`): roda sem instalar. É só abrir.

Não use o arquivo que se chama só `Globalpac-...exe`: esse é o cliente da equipe.

Se o Windows mostrar o aviso do SmartScreen ("O Windows protegeu o seu computador"), clique em **Mais informações** e depois em **Executar assim mesmo**. O aviso aparece porque o programa ainda não tem certificado de assinatura.

### Instalação (só para o instalador)

**1.** Execute o `Globalpac-Suporte-Setup.exe`.

**2.** Clique em **Next** e aceite os termos.

**3.** Mantenha o diretório padrão, **C:\Program Files\RustDesk-Globalpac-Suporte**, e clique em **Next**. Para mudar, clique em **Change…** e escolha outra pasta.

**4.** Clique em **Install**. Ao terminar, o Globalpac-Suporte está pronto para usar.

### Como passar o ID e a senha ao suporte

**1.** Abra o **Globalpac-Suporte**.

**2.** Na tela principal aparecem o **ID** e a **senha** de uso único.

**3.** Envie os dois para o suporte da Globalpac. Não compartilhe com outras pessoas.

**4.** Aguarde a conexão. Não feche o programa enquanto o atendimento estiver em andamento.

O Globalpac-Suporte serve só para receber o atendimento. Ele não conecta a outros computadores.

## Para a equipe

Cliente Windows do [RustDesk](https://github.com/rustdesk/rustdesk) 1.5.3 com a marca Globalpac. O rodapé diz **Desenvolvido por Globalpac**. A licença do cliente é a [AGPL-3.0](https://github.com/rustdesk/rustdesk/blob/1.5.3/LICENCE).

Este repositório não copia o código do RustDesk. O GitHub Actions baixa a tag `1.5.3`, aplica `brand/apply.ps1` e compila o `.exe`.

O que a marca muda:

- nome na janela e no instalador: RustDesk-Globalpac (o instalador do Windows não aceita espaço no nome)
- ícone e logo do site
- servidor gravado: `rustdesk.globalpac.com.br`
- chave pública do nosso hbbs

O pacote interno continua a chamar-se `rustdesk.exe`. Na instalação ele é renomeado para `RustDesk-Globalpac.exe`, que é o arquivo do atalho. O Suporte tem nome próprio, `RustDesk-Globalpac-Suporte`, com configuração, IPC e serviço separados, por isso convive com o cliente completo no mesmo PC. Ele instala em `C:\Program Files\RustDesk-Globalpac-Suporte` e permanece só com ID e senha. Não há certificado de assinatura, por isso o Windows SmartScreen avisa na primeira execução.


## Globalpac Acesso (acesso não assistido)

O **Globalpac-Acesso** é um quarto artefato, separado do Suporte e do cliente completo. Serve para o TI instalar no computador e, depois, entrar a qualquer momento com uma senha permanente, sem alguém precisar aceitar a conexão. Não substitui o Globalpac-Suporte: o Suporte continua só com senha de uso único, para atendimento pontual.

### Termo de ciência do cliente

O acesso não assistido só deve ser instalado com o consentimento informado de quem usa o computador. A pessoa precisa saber, antes da instalação, que:

- o programa fica instalado como serviço do Windows e inicia com a máquina;
- o TI da Globalpac pode ver e usar a tela sem alguém estar na frente do computador e sem um clique de aceite;
- o acesso usa uma senha permanente definida pelo TI, não a senha de uso único do Suporte;
- para encerrar esse tipo de acesso, é preciso desinstalar o Globalpac-Acesso (fechar a janela não encerra o serviço).

Sem esse aceite, use apenas o Globalpac-Suporte, que exige passar o ID e a senha temporária e deixar o programa aberto durante o atendimento.

### Como o TI instala e define a senha

A senha permanente é definida na instalação pelo TI. Ela não vem embutida no `.exe` nem neste repositório.

Instalação silenciosa e senha no mesmo comando (recomendado), em um prompt elevado:

```text
Globalpac-Acesso-Setup.exe --silent-install --password "SUA-SENHA"
```

Se a instalação for feita pela janela do instalador (dois cliques no `Globalpac-Acesso-Setup.exe`), defina a senha depois, também como administrador:

```text
"C:\Program Files\RustDesk-Globalpac-Acesso\RustDesk-Globalpac-Acesso.exe" --password "SUA-SENHA"
```

Troque `SUA-SENHA` por uma senha forte e exclusiva (não reutilize a senha do Windows) e faça a rotação com o mesmo comando `--password` quando for preciso. O valor da senha não deve ser commitado, colado em issue nem gravado no binário.

Pasta de instalação: `C:\Program Files\RustDesk-Globalpac-Acesso`. Nome interno e serviço: `RustDesk-Globalpac-Acesso`. Convive com o Suporte e com o cliente completo no mesmo PC.

O cliente aceita só a senha permanente (`verification-method=use-permanent-password`) e entra sem clique de aceite (`approve-mode=password`). A equipe se conecta a partir do cliente completo (`Globalpac`).

### Agenda e console da equipe

A agenda (Address Book) e o login de conta continuam desligados neste cliente. No RustDesk, a agenda e a console web de frota dependem do **RustDesk Server Pro** (API/console), não só do hbbs/hbbr de código aberto. Fica como próximo passo: avaliar a console Pro da equipe, apontar o `api-server` e só então ligar a agenda no Acesso. Esta entrega não implementa isso.

## Compilar

O fluxo [Cliente Windows Globalpac](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/windows.yml) corre em cada push na `main` e também pode ser disparado à mão. Quando os `.exe` ficam prontos, o fluxo [Publicar release](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/release.yml) publica a versão definida na variável `VERSION` dos workflows `windows.yml` e `release.yml`. A 1.5.1 é a primeira em que o programa instalado busca a release deste repositório e se substitui. A 1.5.2 troca o rodapé para Desenvolvido por Globalpac. A 1.5.3 troca o ícone e a logo pelo quadrado azul com as duas setas brancas. A 1.5.4 desliga conta, agenda e dispositivos (já definida nos workflows; a última release publicada é a 1.5.3). A 1.5.7 sobe a base para o RustDesk 1.5.3. A 1.5.0 continua publicada e não recebe esse aviso.

- `Globalpac-Suporte-{versão}-x86_64.exe` é o do cliente externo, instalável. Abre o ID e a senha de uso único, no estilo QuickSupport. Não deixa ligar a outros computadores.
- `Globalpac-Suporte-Portatil-{versão}-x86_64.exe` é o mesmo Suporte sem instalação: só roda.
- `Globalpac-Acesso-{versão}-x86_64.exe` (e o nome fixo `Globalpac-Acesso-Setup.exe`) é o acesso não assistido, para o TI. Instala o serviço e usa senha permanente definida na instalação.
- `Globalpac-{versão}-x86_64.exe` é o cliente completo, para a equipe.

O fluxo [Aviso RustDesk oficial](https://github.com/Globalpac/Globalpac-Remote/actions/workflows/upstream.yml) compara a release de `rustdesk/rustdesk` com `RUSTDESK_REF`. Se a oficial for maior, abre uma issue. Não altera a base nem compila.

A compilação usa o runner do GitHub. Este PC não precisa de Rust, Flutter nem Visual Studio.
