# Provisionamento FULL

Existe um único fluxo, sem perfis dev/full. Após instalar Ubuntu, Git e clonar este repositório, execute na raiz:

```bash
bash scripts/provision.sh --apply
```

Prévia sem alterações ou downloads:

```bash
bash scripts/provision.sh --dry-run
```

O fluxo instala pacotes Ubuntu, mise/uv, Node/pnpm globais, Docker, GitHub CLI, VS Code, as extensões inventariadas, AWS CLI, Firefox e OnlyOffice. Não instala Terraform/Kubernetes/serviços de IA só por constarem como objetivos no README. Não altera GNOME/NVIDIA nem restaura credenciais.

Use conexão sem franquia para o FULL: runtimes, Docker e editores podem baixar centenas de MB. OnlyOffice exibe os cabeçalhos oficiais e pede confirmação antes do download; o tamanho observado em 23/10/2026 foi 279.357.060 bytes, fora dependências. Fonte: https://helpcenter.onlyoffice.com/desktop/installation/desktop-install-ubuntu.aspx

Logs privados ficam em `~/.local/state/wolf-workstation/`. Um bloqueio impede execuções simultâneas. Em caso de erro, corrija e repita o comando: etapas são reaplicáveis; não se pula uma etapa com marcador antigo. Downloads interrompidos do OnlyOffice podem ser retomados. Se o pacote remoto mudar e a retomada falhar, remova somente o arquivo de cache indicado e tente novamente.

Interações previstas: sudo, autorização de download, autenticação GitHub/AWS, configuração de perfil Firefox e grupo Docker. Para Docker sem sudo: `sudo usermod -aG docker "$USER"`, seguido de logout/login; isso concede acesso equivalente a root. O FULL não altera o grupo automaticamente.

Configuração mise pessoal diferente causa parada segura para mesclagem manual. Dotfiles gerenciados preservam cópia anterior. Reabra o terminal ao terminar.

## Firefox privado

Não exportamos preferências automaticamente do perfil atual: podem conter caminhos pessoais e segredos. Firefox Sync é a opção simples. Para preservar exatamente extensões, cookies e configurações, feche Firefox e identifique a pasta por `about:profiles` (incluindo instalações Snap).

```bash
bash scripts/firefox-profile.sh backup /caminho/perfil /midia/externa/firefox.gpg
bash scripts/firefox-profile.sh restore /midia/externa/firefox.gpg /caminho/novo-perfil
```

Backup pede senha GPG, criptografa todo o perfil e deve ficar fora de qualquer repositório. Guarde a senha separadamente. Restauração nunca sobrescreve um diretório existente; registre o novo perfil em `about:profiles`. Não abra Firefox durante backup/restauração. O script não sincroniza perfis entre versões incompatíveis.

AWS CLI usa o pacote Ubuntu assinado, que pode ter versão diferente do instalador oficial AWS. Credenciais e login são manuais. Atualizações gerais continuam separadas em `scripts/system-update.sh`.

Recovery Test #1: ver [registro](recovery-test-1.md). Validações locais de scripts não substituem teste FULL numa VM limpa.
