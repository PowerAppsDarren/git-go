# 🚀 HYBRID ARCHITECTURE - NEW GLOBAL STANDARD

## ⚡ CRITICAL UPDATE: All Web Apps Must Now Be Hybrid

As of 2025-08-11, following the success of PersonalDashboard (4+ seconds → 200ms), **ALL web applications created by git-go should default to hybrid Electron/Web architecture**.

## 🎯 When Creating New Projects

### For Web Applications
When git-go creates any web application type, it should:

1. **Include Electron structure** by default
2. **Reference the hybrid template** at `~/src/model-hybrid`
3. **Add hybrid scripts** to package.json
4. **Update CLAUDE.md** with hybrid instructions

### Quick Integration
```bash
# When git-go creates a web project, it should also run:
/my-hybrid convert

# Or copy from template:
cp -r ~/src/model-hybrid/electron ./electron
cp ~/src/model-hybrid/electron-builder.yml .
```

## 📊 Application Type Updates

### Web Applications → NOW HYBRID BY DEFAULT
- Static Sites → Can be hybrid (instant local preview)
- SPAs → MUST be hybrid (huge performance gains)
- PWAs → SHOULD be hybrid (best of both worlds)
- SaaS Dashboards → MUST be hybrid (daily use tools)
- Enterprise Apps → MUST be hybrid (productivity)
- E-commerce → CAN be hybrid (admin panels)

### Desktop Applications → ALREADY HYBRID COMPATIBLE
- Electron Apps → Update to include web mode
- Native Apps → Consider hybrid alternative

## 🔧 What git-go Should Create

### Updated Project Structure
```
new-project/
├── README.md
├── CLAUDE.md            # Updated with hybrid info
├── LICENSE
├── .gitignore
├── package.json         # With hybrid scripts
├── electron/            # NEW - Desktop runtime
│   ├── main.js
│   └── preload.js
├── client/              # Frontend
│   └── lib/
│       └── electron-bridge.ts  # NEW - Dual detection
├── server/              # Backend
├── scripts/
│   ├── sync.sh          # Existing git-go sync
│   └── launch-hybrid.sh # NEW - Hybrid launcher
├── .vscode/
│   └── tasks.json       # Updated with hybrid tasks
└── electron-builder.yml # NEW - Desktop packaging
```

### Updated CLAUDE.md Template
```markdown
# CLAUDE.md

This project uses **HYBRID ELECTRON/WEB ARCHITECTURE** - the new global standard.

## Quick Start
- **Desktop Mode**: `npm run electron` (⚡ 200ms launch)
- **Web Mode**: `npm run dev` (🌐 Network accessible)
- **Hybrid Mode**: `npm run hybrid` (🚀 Both running!)

## Architecture
- Desktop app with system tray and global hotkeys
- Web server for browser/mobile access
- Shared codebase and database
- Smart environment detection

See: ~/dev-knowledge/hybrid-electron-web-stack.md
```

### Updated package.json Scripts
```json
{
  "main": "electron/main.js",
  "scripts": {
    "dev": "vite",
    "electron": "electron .",
    "hybrid": "concurrently \"npm run dev\" \"npm run electron\"",
    "build": "vite build",
    "dist": "electron-builder"
  }
}
```

## 🎯 Implementation for git-go

### Option 1: Auto-Detect and Convert
```bash
# In git-go's create_new_repo function
if [[ "$app_type" == "Web Application" ]]; then
    echo "🚀 Adding hybrid Electron/Web support (new standard)..."
    /my-hybrid convert
fi
```

### Option 2: Use Template
```bash
# When creating web projects
if [[ -d ~/src/model-hybrid ]]; then
    cp -r ~/src/model-hybrid/electron "$repo_dir/"
    cp ~/src/model-hybrid/electron-builder.yml "$repo_dir/"
fi
```

### Option 3: Update Templates
Git-go should maintain hybrid-ready templates for common frameworks:
- `react-hybrid/`
- `vue-hybrid/`
- `next-hybrid/`
- `svelte-hybrid/`

## 📈 Benefits for git-go Users

1. **Every web project** is instantly desktop-ready
2. **No more slow Docker loads** for development
3. **Professional apps** from day one
4. **User choice** - they can use web or desktop
5. **Future-proof** - ready for any deployment

## 🚨 Priority

This is **HIGH PRIORITY**. All new web projects created by git-go should be hybrid by default. This aligns with the global standard documented in:
- `~/CLAUDE.md` - Global configuration
- `~/dev-knowledge/hybrid-electron-web-stack.md` - Technical guide
- `~/dev-knowledge/NEW-GLOBAL-STANDARD-HYBRID-APPS.md` - The mandate

## 🔄 Migration Path

For existing git-go functionality:
1. Keep current behavior as fallback
2. Add hybrid as default for web apps
3. Provide `--no-hybrid` flag for legacy mode
4. Update documentation

---

*Updated: 2025-08-11*
*Standard Template: ~/src/model-hybrid*
*Global Command: /my-hybrid*