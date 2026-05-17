# MedRound — Sistema Hospitalar Inteligente
Gestão de enfermaria · HUAP/UFF · Clínica Médica

---

## Deploy em 3 passos

### 1. Supabase (banco de dados + realtime)

1. Acesse [supabase.com](https://supabase.com) → **New project**
2. Anote: **Project URL** e **anon public key** (Settings → API)
3. Vá em **SQL Editor → New query**, cole o conteúdo de `supabase_setup.sql` e clique **Run**
4. Em **Settings → API → Realtime**, certifique-se que `medrounddata` está habilitada

### 2. GitHub

```bash
git init
git add .
git commit -m "feat: MedRound v1"
git remote add origin https://github.com/SEU_USUARIO/medroundapp.git
git push -u origin main
```

### 3. Vercel

1. Acesse [vercel.com](https://vercel.com) → **Add New Project** → importe o repo GitHub
2. Em **Environment Variables**, adicione:
   - `SUPABASE_URL` → cole a Project URL do Supabase
   - `SUPABASE_ANON_KEY` → cole a anon key do Supabase
3. Clique **Deploy**

> O Vercel injeta as variáveis via `window.__env` automaticamente. O app detecta e conecta ao Supabase sem configuração manual.

---

## Configuração manual (sem Vercel env vars)

Abra o app → clique em **☁️** no header → cole URL e chave → salvar.

---

## Estrutura de arquivos

```
medroundapp/
├── index.html          # App completo (single-file PWA)
├── manifest.json       # PWA manifest
├── icon.svg            # Ícone vetorial
├── icon-192.png        # Ícone 192×192 (gerar do SVG)
├── icon-512.png        # Ícone 512×512 (gerar do SVG)
├── vercel.json         # Config de deploy
├── supabase_setup.sql  # Script SQL de setup
└── .gitignore
```

---

## Tecnologias

- **Frontend**: HTML/CSS/JS puro — zero dependências de build
- **Banco**: Supabase (PostgreSQL + Realtime)
- **Hosting**: Vercel (CDN global)
- **PWA**: Funciona offline, instalável no celular/iPad
- **Importação**: DOCX, PDF, TXT via FileReader API

---

## Tabela do Supabase

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | text PK | Sempre `'main'` (single-row pattern) |
| `data` | jsonb | `{cmm: [...], cmf1: [...], cmf2: [...]}` |
| `updated_at` | timestamptz | Atualizado automaticamente via trigger |

---

## Segurança

- RLS habilitado na tabela
- Políticas anônimas (sem autenticação) para uso hospitalar interno
- Para adicionar autenticação: use Supabase Auth + ajuste as policies no SQL

---

## Instalação como PWA

**iPhone/iPad**: Safari → Compartilhar → "Adicionar à Tela de Início"  
**Android**: Chrome → Menu (⋮) → "Adicionar à tela inicial"  
**Desktop**: Chrome/Edge → ícone de instalação na barra de endereço
