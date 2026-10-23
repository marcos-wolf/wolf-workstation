# Recovery Test #1 — concluído

Resultado: recuperação após formatação concluída, conforme confirmação do usuário em 23/10/2026. O novo provisionamento FULL ainda precisa de um teste separado numa instalação limpa; não foi executado sobre o sistema atual.

Ambiente: Ubuntu 26.04.1 LTS, GNOME, NVIDIA no Lenovo LOQ. Inspeção de 23/10 confirmou Ubuntu 26.04.1, GNOME Shell 50.1 e as 13 extensões listadas em `config/vscode-extensions.txt`. Não foram alterados GNOME, drivers, partições ou dados pessoais. A versão do driver registrada em system.md é inventário anterior, não nova medição.

## Problemas e soluções incorporadas

- mise: instalar runtimes no projeto não os torna globais. O bootstrap agora instala a configuração global do Node/pnpm; recusa conflito com configuração pessoal existente e orienta resolução manual.
- Docker: acesso sem sudo exige grupo docker e nova sessão de login. O grupo equivale a acesso privilegiado; a inclusão continua explícita.
- VS Code/GPG: arquivo temporário de saída já existente fazia GPG solicitar confirmação. Usar `--batch --yes` para converter a chave pública de repositório.
- VS Code: as 13 extensões recuperadas foram inventariadas e entram no FULL.
- AWS CLI: disponível durante recuperação; automação futura usa pacote assinado do Ubuntu, sem credenciais. Isso difere do instalador AWS v2 descrito anteriormente.
- Firefox: configuração privada não vai ao Git. Sync e backup criptografado do perfil fechado são opções; restauração cria diretório novo e exige seleção explícita do perfil.

A conclusão do teste é relato do usuário. Não há logs completos disponíveis dos testes anteriores para afirmar novas execuções de builds, recuperação de arquivos pessoais ou autenticação AWS. Credenciais continuam separadas.
