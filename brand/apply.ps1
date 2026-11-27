param(
    [Parameter(Mandatory = $true)]
    [string]$BrandDir
)

$ErrorActionPreference = "Stop"

function Replace-Once {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New
    )
    $text = [System.IO.File]::ReadAllText($Path)
    $count = ([regex]::Matches($text, [regex]::Escape($Old))).Count
    if ($count -ne 1) {
        throw "Esperava 1 ocorrencia em ${Path}, achei ${count}: ${Old}"
    }
    $updated = $text.Replace($Old, $New)
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $updated, $utf8)
}

$root = (Get-Location).Path
$brand = (Resolve-Path $BrandDir).Path

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old 'RwLock::new("RustDesk".to_owned())' `
    -New 'RwLock::new("RustDesk-Globalpac".to_owned())'

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old '&["rs-ny.rustdesk.com"]' `
    -New '&["rustdesk.globalpac.com.br"]'

Replace-Once `
    -Path (Join-Path $root "libs\hbb_common\src\config.rs") `
    -Old 'OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=' `
    -New 'kwrVksGnr7O5FGpxqiPTGWKsi2mksEtI7B1DvoHfykc='

$runner = Join-Path $root "flutter\windows\runner\Runner.rc"
Replace-Once -Path $runner -Old 'VALUE "FileDescription", "RustDesk Remote Desktop"' -New 'VALUE "FileDescription", "RustDesk Globalpac"'
Replace-Once -Path $runner -Old 'VALUE "ProductName", "RustDesk"' -New 'VALUE "ProductName", "RustDesk-Globalpac"'
Replace-Once -Path $runner -Old 'VALUE "CompanyName", "Purslane Tech Pte. Ltd."' -New 'VALUE "CompanyName", "Globalpac"'

Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "res\icon.ico") -Force
Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "res\tray-icon.ico") -Force
Copy-Item (Join-Path $brand "app_icon.ico") (Join-Path $root "flutter\windows\runner\resources\app_icon.ico") -Force
Copy-Item (Join-Path $brand "icon.png") (Join-Path $root "res\icon.png") -Force
Copy-Item (Join-Path $brand "icon.png") (Join-Path $root "flutter\assets\icon.png") -Force
Copy-Item (Join-Path $brand "logo.png") (Join-Path $root "flutter\assets\logo.png") -Force
Copy-Item (Join-Path $brand "logo.png") (Join-Path $root "flutter\assets\logo_light.png") -Force
Copy-Item (Join-Path $brand "logo_dark.png") (Join-Path $root "flutter\assets\logo_dark.png") -Force

$qsOld = 'exe.contains("-qs-") || exe.contains("-qs.exe") || exe.contains("_qs.exe")'
$qsNew = 'exe.contains("-qs-") || exe.contains("-qs.exe") || exe.contains("_qs.exe") || exe.contains("suporte")'
Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old $qsOld -New $qsNew
# No empacotador so o Suporte portatil abre direto no modo Suporte; o instalavel segue para o instalador.
$qsPackerNew = 'exe.contains("-qs-") || exe.contains("-qs.exe") || exe.contains("_qs.exe") || (exe.contains("suporte") && exe.contains("portatil"))'
Replace-Once -Path (Join-Path $root "libs\portable\src\main.rs") -Old $qsOld -New $qsPackerNew

$common = Join-Path $root "src\common.rs"
$marker = @'
pub fn globalpac_support_marker_exists() -> bool {
    std::env::current_exe()
        .ok()
        .and_then(|exe| exe.parent().map(|dir| dir.join("globalpac-suporte.txt")))
        .map(|path| path.exists())
        .unwrap_or(false)
}

pub const GLOBALPAC_SUPPORT_APP_NAME: &str = "RustDesk-Globalpac-Suporte";

fn globalpac_portable_name_contains(word: &str) -> bool {
    std::env::var(PORTABLE_APPNAME_RUNTIME_ENV_KEY)
        .map(|value| value.to_lowercase().contains(word))
        .unwrap_or(false)
}

pub fn globalpac_is_suporte() -> bool {
    std::env::var("GLOBALPAC_SUPPORT").ok().as_deref() == Some("1")
        || globalpac_support_marker_exists()
        || globalpac_portable_name_contains("suporte")
        || std::env::current_exe()
            .ok()
            .and_then(|path| path.to_str().map(|value| value.to_lowercase().contains("suporte")))
            .unwrap_or(false)
}

pub fn globalpac_is_portatil() -> bool {
    globalpac_portable_name_contains("portatil")
}

pub fn globalpac_acesso_marker_exists() -> bool {
    std::env::current_exe()
        .ok()
        .and_then(|exe| exe.parent().map(|dir| dir.join("globalpac-acesso.txt")))
        .map(|path| path.exists())
        .unwrap_or(false)
}

pub const GLOBALPAC_ACESSO_APP_NAME: &str = "RustDesk-Globalpac-Acesso";

pub fn globalpac_is_acesso() -> bool {
    std::env::var("GLOBALPAC_ACESSO").ok().as_deref() == Some("1")
        || globalpac_acesso_marker_exists()
        || globalpac_portable_name_contains("acesso")
        || std::env::current_exe()
            .ok()
            .and_then(|path| path.to_str().map(|value| value.to_lowercase().contains("acesso")))
            .unwrap_or(false)
}

// Nome proprio do Suporte e do Acesso: separam IPC, config, log, registro e servico.
pub fn globalpac_apply_app_name() {
    if globalpac_is_suporte() {
        std::env::set_var("GLOBALPAC_SUPPORT", "1");
        *config::APP_NAME.write().unwrap() = GLOBALPAC_SUPPORT_APP_NAME.to_owned();
    } else if globalpac_is_acesso() {
        std::env::set_var("GLOBALPAC_ACESSO", "1");
        *config::APP_NAME.write().unwrap() = GLOBALPAC_ACESSO_APP_NAME.to_owned();
    }
}

// O Suporte instalavel abre o instalador quando ainda nao esta instalado.
pub fn globalpac_suporte_click_setup() -> bool {
    #[cfg(windows)]
    {
        globalpac_is_suporte() && !globalpac_is_portatil() && !crate::platform::is_installed()
    }
    #[cfg(not(windows))]
    {
        false
    }
}

// O Acesso abre o instalador quando ainda nao esta instalado, para criar o servico.
pub fn globalpac_acesso_click_setup() -> bool {
    #[cfg(windows)]
    {
        globalpac_is_acesso() && !crate::platform::is_installed()
    }
    #[cfg(not(windows))]
    {
        false
    }
}

pub fn globalpac_update_prefix() -> &'static str {
    if globalpac_is_suporte() {
        "Globalpac-Suporte"
    } else if globalpac_is_acesso() {
        "Globalpac-Acesso"
    } else {
        "Globalpac"
    }
}

pub fn globalpac_check_update() -> ResultType<()> {
    let url = "https://api.github.com/repos/Globalpac/Globalpac-Remote/releases/latest";
    let client = crate::hbbs_http::create_http_client_with_url_strict(url)?;
    let response = client
        .get(url)
        .header("User-Agent", "Globalpac-Remote")
        .header("Accept", "application/vnd.github+json")
        .send()?;
    if !response.status().is_success() {
        bail!(
            "Falha ao consultar a release Globalpac: {}",
            response.status()
        );
    }
    let body: Value = response.json()?;
    let tag = body
        .get("tag_name")
        .and_then(|value| value.as_str())
        .unwrap_or_default()
        .trim_start_matches('v');
    if tag.is_empty() {
        bail!("Release Globalpac sem tag");
    }
    if get_version_number(tag) > get_version_number(crate::VERSION) {
        *SOFTWARE_UPDATE_URL.lock().unwrap() =
            format!("https://github.com/Globalpac/Globalpac-Remote/releases/tag/v{tag}");
    } else {
        *SOFTWARE_UPDATE_URL.lock().unwrap() = "".to_string();
    }
    Ok(())
}

pub fn globalpac_apply_server() {
    {
        let mut hard = config::HARD_SETTINGS.write().unwrap();
        hard.insert("disable-account".to_owned(), "Y".to_owned());
        hard.insert("disable-ab".to_owned(), "Y".to_owned());
    }
    config::LocalConfig::set_option("disable-group-panel".to_owned(), "Y".to_owned());
    config::Config::set_option("allow-auto-update".to_owned(), "Y".to_owned());
    config::Config::set_option(
        "custom-rendezvous-server".to_owned(),
        "rustdesk.globalpac.com.br".to_owned(),
    );
    config::Config::set_option(
        "relay-server".to_owned(),
        "rustdesk.globalpac.com.br".to_owned(),
    );
    config::Config::set_option(
        "key".to_owned(),
        "kwrVksGnr7O5FGpxqiPTGWKsi2mksEtI7B1DvoHfykc=".to_owned(),
    );
}

pub fn globalpac_apply_incoming() {
    std::env::set_var("GLOBALPAC_SUPPORT", "1");
    {
        let mut hard = config::HARD_SETTINGS.write().unwrap();
        hard.insert("conn-type".to_owned(), "incoming".to_owned());
        hard.insert("disable-settings".to_owned(), "Y".to_owned());
        hard.insert("disable-ab".to_owned(), "Y".to_owned());
        if globalpac_is_portatil() {
            hard.insert("disable-installation".to_owned(), "Y".to_owned());
        }
    }
    config::BUILTIN_SETTINGS
        .write()
        .unwrap()
        .insert("hide-help-cards".to_owned(), "Y".to_owned());
    config::Config::set_option(
        "verification-method".to_owned(),
        "use-temporary-password".to_owned(),
    );
}

pub fn globalpac_password_arg(args: &[String]) -> Option<String> {
    let mut i = 0;
    while i < args.len() {
        if args[i] == "--password" && i + 1 < args.len() {
            let value = args[i + 1].clone();
            if !value.is_empty() && !value.starts_with('-') {
                return Some(value);
            }
        }
        i += 1;
    }
    None
}

// Depois do --silent-install do Acesso, grava a senha passada em --password. Nao registra o valor.
pub fn globalpac_acesso_after_silent_install(args: &[String], res: &ResultType<()>) {
    if !globalpac_is_acesso() {
        return;
    }
    if res.is_err() {
        return;
    }
    if let Some(password) = globalpac_password_arg(args) {
        match crate::ipc::set_permanent_password(password) {
            Ok(()) => println!("Senha permanente definida."),
            Err(err) => println!("Falha ao gravar a senha permanente: {err}"),
        }
    } else {
        println!("Instalacao concluida. Defina a senha permanente como administrador:");
        println!("  RustDesk-Globalpac-Acesso.exe --password \"SUA-SENHA\"");
    }
}

pub fn globalpac_apply_acesso() {
    std::env::set_var("GLOBALPAC_ACESSO", "1");
    {
        let mut hard = config::HARD_SETTINGS.write().unwrap();
        hard.insert("approve-mode".to_owned(), "password".to_owned());
        hard.insert(
            "verification-method".to_owned(),
            "use-permanent-password".to_owned(),
        );
    }
    config::Config::set_option("approve-mode".to_owned(), "password".to_owned());
    config::Config::set_option(
        "verification-method".to_owned(),
        "use-permanent-password".to_owned(),
    );
}

'@
$marker = $marker.Replace("`r`n", "`n")
Replace-Once -Path $common -Old "fn read_custom_client_advanced_settings(" -New ($marker + "fn read_custom_client_advanced_settings(")
Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old "_is_quick_support |= !crate::platform::is_installed()" -New "let globalpac_incoming = _is_quick_support || crate::common::globalpac_support_marker_exists();`r`n        if globalpac_incoming {`r`n            _is_quick_support = true;`r`n        }`r`n        crate::common::globalpac_apply_server();`r`n        _is_quick_support |= !crate::platform::is_installed()"
Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old "crate::portable_service::client::set_quick_support(_is_quick_support);" -New "crate::portable_service::client::set_quick_support(_is_quick_support);`r`n        if globalpac_incoming {`r`n            crate::common::globalpac_apply_incoming();`r`n        }`r`n        if crate::common::globalpac_is_acesso() {`r`n            crate::common::globalpac_apply_acesso();`r`n        }"

Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old "crate::load_custom_client();" -New "crate::common::globalpac_apply_app_name();`n    crate::load_custom_client();"
Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old "let click_setup = cfg!(windows) && args.is_empty() && crate::common::is_setup(&arg_exe);" -New "let click_setup = cfg!(windows)`n        && args.is_empty()`n        && (crate::common::is_setup(&arg_exe) || crate::common::globalpac_suporte_click_setup() || crate::common::globalpac_acesso_click_setup());"

$windows = Join-Path $root "src\platform\windows.rs"
$copyPrep = @'
let main_exe = copy_raw_cmd(src_exe, exe, path)?;
    let rename_exe = rename_exe_cmd(src_exe, path)?;
    let support_marker = if std::env::var("GLOBALPAC_SUPPORT").ok().as_deref() == Some("1") {
        format!("echo globalpac>\"{path}\\globalpac-suporte.txt\"")
    } else if std::env::var("GLOBALPAC_ACESSO").ok().as_deref() == Some("1") {
        format!("echo globalpac>\"{path}\\globalpac-acesso.txt\"")
    } else {
        String::new()
    };
'@
Replace-Once -Path $windows -Old 'let main_exe = copy_raw_cmd(src_exe, exe, path)?;' -New ($copyPrep.Replace("`r`n", "`n").TrimEnd())
$copyLine = @'
copy /Y \"{ORIGIN_PROCESS_EXE}\" \"{path}\\{broker_exe}\"
        {rename_exe}
        {support_marker}
'@
Replace-Once -Path $windows -Old 'copy /Y \"{ORIGIN_PROCESS_EXE}\" \"{path}\\{broker_exe}\"' -New ($copyLine.Replace("`r`n", "`n").TrimEnd())
Replace-Once -Path $windows -Old 'broker_exe = win_topmost_window::INJECTED_PROCESS_EXE,' -New "broker_exe = win_topmost_window::INJECTED_PROCESS_EXE,`n        rename_exe = rename_exe,`n        support_marker = support_marker,"

Replace-Once -Path (Join-Path $root "src\core_main.rs") -Old 'let res = platform::install_me(options, "".to_owned(), true, debug);' -New ('let res = platform::install_me(options, "".to_owned(), true, debug);' + "`r`n                crate::common::globalpac_acesso_after_silent_install(&args, &res);")

if ([string]::IsNullOrWhiteSpace($env:VERSION)) {
    throw "A variavel VERSION nao esta definida"
}
Replace-Once -Path (Join-Path $root "Cargo.toml") -Old 'version = "1.5.0"' -New "version = `"$($env:VERSION)`""
$lockPath = Join-Path $root "Cargo.lock"
$lockText = [System.IO.File]::ReadAllText($lockPath)
$lockPattern = '(?m)^name = "rustdesk"\r?\nversion = "1.5.0"'
$lockCount = ([regex]::Matches($lockText, $lockPattern)).Count
if ($lockCount -ne 1) {
    throw "Esperava 1 pacote rustdesk 1.5.0 no Cargo.lock, achei ${lockCount}"
}
$lockNewline = if ($lockText.Contains("`r`n")) { "`r`n" } else { "`n" }
$lockUpdated = [regex]::Replace(
    $lockText,
    $lockPattern,
    ("name = `"rustdesk`"{0}version = `"{1}`"" -f $lockNewline, $env:VERSION),
    1
)
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($lockPath, $lockUpdated, $utf8)

$updater = Join-Path $root "src\updater.rs"
Replace-Once -Path $updater -Old 'if do_check_software_update().is_err()' -New 'if crate::common::globalpac_check_update().is_err()'
Replace-Once -Path $updater -Old 'let version = download_url.split(''/'').last().unwrap_or_default();' -New @'
let version = download_url.split('/').last().unwrap_or_default().trim_start_matches('v');
        let version = format!("{}-{}", crate::common::globalpac_update_prefix(), version);
'@.Replace("`r`n", "`n").TrimEnd()
Replace-Once -Path $updater -Old '"{}/rustdesk-{}-{}.{}"' -New '"{}/{}-{}.{}"'
Replace-Once -Path $updater -Old 'if owner != "rustdesk"' -New 'if !((owner == "rustdesk" && repo == "rustdesk") || (owner == "Globalpac" && repo == "Globalpac-Remote"))'
Replace-Once -Path $updater -Old '|| repo != "rustdesk"' -New '|| false'

$flutterCommon = Join-Path $root "flutter\lib\common.dart"
Replace-Once -Path $flutterCommon -Old "launchUrl(Uri.parse('https://rustdesk.com'));" -New "launchUrl(Uri.parse('https://globalpac.com.br'));"
$loginDialog = Join-Path $root "flutter\lib\common\widgets\login.dart"
Replace-Once -Path $loginDialog -Old "Future<bool?> loginDialog() {" -New "Future<bool?> loginDialog() { return Future.value(null); }`n`nFuture<bool?> loginDialogUnusedGlobalpac() {"
Replace-Once -Path $flutterCommon -Old 'translate("powered_by_me"),' -New '"Desenvolvido por Globalpac",'

Write-Host "Marca Globalpac aplicada em $root"
