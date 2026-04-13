set nocompatible
set confirm
set termguicolors
set vb

set clipboard+=unnamedplus
set undofile

set ignorecase
set smartcase
set incsearch

set number
set showmatch

set splitright
set colorcolumn=80
set scrolloff=3
set signcolumn=yes

set wildmenu
set wildmode=list:longest,full
set wildoptions=pum

set encoding=utf-8
set showcmd
set showmode

set autoindent
set backspace=indent,eol,start

" Spaces instead of tabs
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

filetype plugin indent on
syntax enable

autocmd VimResized * wincmd =
autocmd BufLeave,FocusLost * silent! wall

lua << EOF
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function()
      vim.opt_local.colorcolumn = '100'
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.tabstop = 4
    end
  })
EOF

"{{{ vim-plug
call plug#begin()

  Plug 'windwp/nvim-autopairs'
  Plug 'machakann/vim-sandwich'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-repeat'
  Plug 'unblevable/quick-scope'

  Plug 'folke/persistence.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'master', 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-context'

  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'aznhe21/actions-preview.nvim'

  Plug 'nvim-lualine/lualine.nvim'
  Plug 'stevearc/dressing.nvim'
  Plug 'folke/noice.nvim'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'SmiteshP/nvim-navic'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " Color scheme
  Plug 'morhetz/gruvbox'

  if (!exists('g:vscode'))
    Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}
    Plug 'mikesmithgh/kitty-scrollback.nvim'
    Plug 'tpope/vim-commentary'
  endif

call plug#end()
"}}}

"{{{Look and Feel

let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

"}}}

"{{{ Mappings

let mapleader=" "

nnoremap ; :
nnoremap : ;
nnoremap <silent> n  nzz
nnoremap <silent> N  Nzz
nnoremap <silent> *  *zz
nnoremap <silent> #  #zz
nnoremap <silent> g* g*zz

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>fo <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>ft <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Copy filepath to clipboard
nnoremap <leader>yp :let @*=expand('%')<CR>:echo 'Copied: ' . expand('%')<CR>
nnoremap <leader>yP :let @*=expand('%:p')<CR>:echo 'Copied: ' . expand('%:p')<CR>
nnoremap <leader>yf :let @*=expand('%:t')<CR>:echo 'Copied: ' . expand('%:t')<CR>
nnoremap <leader>yd :let @*=expand('%:h')<CR>:echo 'Copied: ' . expand('%:h')<CR>

if exists('g:vscode')
  map <C-J> <C-W>j
  map <C-K> <C-W>k
  map <C-H> <C-W>h
  map <C-L> <C-W>l

  vnoremap <leader>ff <cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>
  nmap <silent> gf <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

  nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
  nmap <silent> gy <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
  nmap <silent> go <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
  nmap <silent> gt <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
  nmap <silent> gn <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
  nmap <silent> gp <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
  nmap <silent> ge <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>

  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
endif

"}}}

if exists('g:vscode')
  highlight QuickScopePrimary guifg='#58822f' gui=underline ctermfg=155 cterm=underline
  highlight QuickScopeSecondary guifg='#3aa0a6' gui=underline ctermfg=81 cterm=underline
endif

if !exists('g:vscode')
lua << EOF
-- jump to last edit position on opening file
  vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function(ev)
      if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
        -- except for in git commit messages
        -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
        if not vim.fn.expand('%:p'):find('.git', 1, true) then
          vim.cmd('exe "normal! g\'\\""')
        end
      end
    end
  })

  local function format_rust_file(filepath)
    -- If no filepath provided, use current buffer
    if not filepath then
      filepath = vim.fn.expand('%:p')
    end

    -- Ensure filepath is a string and not empty
    if not filepath or type(filepath) ~= 'string' or filepath == '' then
      return
    end

    -- Only format Rust files
    if not string.match(filepath, '%.rs$') then
      return
    end

    -- Find the Cargo.toml directory
    local cargo_dir = vim.fn.fnamemodify(vim.fn.findfile('Cargo.toml', filepath .. ';'), ':h')

    if cargo_dir == '' then
      vim.notify('No Cargo.toml found for: ' .. filepath, vim.log.levels.WARN)
      return
    end

    -- Run cargo fmt from the project root
    local cmd = string.format('cd %s && cargo fmt -- %s',
      vim.fn.shellescape(cargo_dir),
      vim.fn.shellescape(filepath))
    local output = vim.fn.system(cmd)

    if vim.v.shell_error == 0 then
      vim.cmd('checktime')
    else
      vim.notify('cargo fmt: syntax error', vim.log.levels.WARN)
    end
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.rs",
    callback = format_rust_file,
  })

  vim.api.nvim_create_autocmd({"BufLeave", "FocusLost"}, {
    pattern = "*.rs",
    callback = function(ev)
      local filepath = vim.api.nvim_buf_get_name(ev.buf)
      if filepath ~= '' and vim.fn.filereadable(filepath) == 1 then
        -- Wait for auto-save to complete, then format
        vim.defer_fn(function()
          -- Double-check the buffer still exists and has the same file
          if vim.api.nvim_buf_is_valid(ev.buf) then
            local current_file = vim.api.nvim_buf_get_name(ev.buf)
            if current_file == filepath then
              format_rust_file(filepath)  -- Pass the filepath explicitly
            end
          end
        end, 100)
      end
    end,
  })

  vim.keymap.set("n", "<leader>qs", function()
    require("persistence").load()
  end, { desc = "Restore Session" })

  vim.keymap.set("n", "<leader>qS", function()
    require("persistence").select()
  end, { desc = "Select Session" })

  vim.keymap.set("n", "<leader>ql", function()
    require("persistence").load({ last = true })
  end, { desc = "Restore Last Session" })

  vim.keymap.set("n", "<leader>qd", function()
    require("persistence").stop()
  end, { desc = "Don't Save Current Session" })

  -- highlight yanked text
  vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
  })

  -- Configure Telescope
  local telescope_actions = require('telescope.actions')
  local telescope_action_state = require('telescope.actions.state')

  require('telescope').setup({
    defaults = {
      preview = {
        filetype_hook = function(_, _, opts)
          vim.wo[opts.winid].number = true
          return true
        end,
      },
      mappings = {
        i = {
          ["<C-d>"] = telescope_actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = telescope_actions.delete_buffer,
          ["dd"] = telescope_actions.delete_buffer,
        },
      },
    },
    pickers = {
      buffers = {
        sort_mru = true,
      },
      lsp_document_symbols = {
        entry_maker = function(entry)
          local make_entry = require('telescope.make_entry')
          local entry_display = require('telescope.pickers.entry_display')
          local displayer = entry_display.create {
            separator = ' ',
            hl_chars = { ['['] = 'TelescopeBorder', [']'] = 'TelescopeBorder' },
            items = {
              { width = 5 },
              { width = 25 },
              { remaining = true },
            },
          }
          local lsp_type_highlight = {
            ['Class']     = 'TelescopeResultsClass',
            ['Function']  = 'TelescopeResultsFunction',
            ['Method']    = 'TelescopeResultsMethod',
            ['Variable']  = 'TelescopeResultsVariable',
            ['Field']     = 'TelescopeResultsField',
            ['Interface'] = 'TelescopeResultsOperator',
            ['Module']    = 'TelescopeResultsStruct',
            ['Struct']    = 'TelescopeResultsStruct',
            ['Constant']  = 'TelescopeResultsConstant',
            ['Property']  = 'TelescopeResultsField',
          }
          local default_entry = make_entry.gen_from_lsp_symbols({})(entry)
          if not default_entry then return nil end
          default_entry.display = function(e)
            return displayer {
              { tostring(e.lnum), 'TelescopeResultsLineNr' },
              e.symbol_name,
              { '[' .. (e.symbol_type or ''):lower() .. ']',
                lsp_type_highlight[e.symbol_type] or 'TelescopeResultsComment' },
            }
          end
          return default_entry
        end,
      },
    },
  })

  require('telescope').load_extension('fzf')

  require('kitty-scrollback').setup({
    {
      keymaps_enabled = true,
      restore_options = true,
      callbacks = {
        after_ready = function()
          -- After a yank, the plugin moves cursor to bottom. Restore position.
          vim.api.nvim_create_autocmd('TextYankPost', {
            buffer = 0,
            callback = function()
              if vim.v.event.operator == 'y' then
                local pos = vim.w.ksb_pre_yank_pos
                local win = vim.api.nvim_get_current_win()
                if pos then
                  -- Use defer_fn to run after the plugin's own vim.schedule cursor move
                  local view = vim.w.ksb_pre_yank_view
                  vim.defer_fn(function()
                    pcall(vim.api.nvim_win_set_cursor, win, pos)
                    if view then vim.fn.winrestview(view) end
                  end, 10)
                end
              end
            end,
          })
          -- Store cursor position and view before each yank
          vim.keymap.set({ 'n', 'v' }, 'y', function()
            vim.w.ksb_pre_yank_pos = vim.api.nvim_win_get_cursor(0)
            vim.w.ksb_pre_yank_view = vim.fn.winsaveview()
            return 'y'
          end, { buffer = true, expr = true, nowait = true })
        end,
      },
    },
  })

  local function get_target_window_for_split()
    -- Get all normal windows in the current tab
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local normal = {}
    for _, w in ipairs(wins) do
      if vim.api.nvim_win_get_config(w).relative == "" then
        table.insert(normal, w)
      end
    end

    local current_win = vim.api.nvim_get_current_win()
    local win_index = nil
    for i, w in ipairs(normal) do
      if w == current_win then
        win_index = i
        break
      end
    end

    if win_index == 1 and #normal == 1 then
      -- Leftmost and only window: create new vsplit
      vim.cmd("vsplit")
      return vim.api.nvim_get_current_win()
    elseif win_index == 1 and #normal > 1 then
      -- Leftmost with window to right: use window to right
      return normal[2]
    elseif win_index == 2 then
      -- Second split: create third vsplit
      vim.cmd("vsplit")
      return vim.api.nvim_get_current_win()
    elseif win_index == 3 then
      -- Third split: use same window
      return current_win
    end
  end

  local function grep_in_split(opts)
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    builtin.grep_string(vim.tbl_extend("force", opts or {}, {
      attach_mappings = function(prompt_bufnr, map)
        local function open_in_split()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          local win = get_target_window_for_split()
          vim.api.nvim_set_current_win(win)
          vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
          if entry.lnum and entry.col then
            vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
          end
        end

        map("i", "<CR>", open_in_split)
        map("n", "<CR>", open_in_split)
        return true
      end,
    }))
  end

  vim.keymap.set("n", "<leader>fw", grep_in_split, 
    { desc = "Grep word under cursor in vsplit" })
  vim.keymap.set("v", "<leader>fw", 
    function()
      local text = table.concat(vim.fn.getreg("v", 1, true), "\n")
      grep_in_split({ search = text })
    end, 
    { desc = "Grep selection in vsplit" })

  require('nvim-autopairs').setup({})

  local cmp = require('cmp')
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
  })
                                        
  vim.o.completeopt = 'menu,menuone,noselect'

  local navic = require("nvim-navic")
  navic.setup({ 
    highlight = true,
    lazy_update_context = false,
  })

  require("lualine").setup({
    options = {
      theme = 'gruvbox',
      refresh = {
        refresh_time = 16,
        events = {
          'CursorMoved',
          'CursorMovedI',
          'ModeChanged',
          'BufEnter',
          'WinEnter',
          'BufWritePost',
          'DiagnosticChanged',
          'LspAttach',
          'LspDetach',
          'FileType',
          'VimResized',
          'FocusGained',
          'TermResponse',
          'SessionLoadPost',
          'FileChangedShellPost',
        },
      },
    },
    sections = {
      lualine_c = {
        { 'filename', path = 1 },
        { function() return navic.get_location() end },
      }
    },
  })

  local lsp = require('lspconfig')
  local util = require('lspconfig').util
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lsp_flags = { debounce_text_changes = 150 }

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', 'gd',
      function()
        local win = get_target_window_for_split()
        vim.api.nvim_set_current_win(win)
        vim.lsp.buf.definition()
      end,
      bufopts)

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set({'n','v'}, '<C-.>', require('actions-preview').code_actions, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
  end

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "rust_analyzer", "ts_ls", "lua_ls", "pyright", "yamlls" },
    automatic_installation = false,
  })

  vim.lsp.config('ts_ls', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })

  vim.lsp.config('rust_analyzer', {
    on_attach = on_attach,
    flags = vim.tbl_extend('force', lsp_flags, { allow_incremental_sync = false }),
    capabilities = capabilities,
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true, allTargets = true, cfgs = { test = "" } },
        check = { command = 'clippy' },
        checkOnSave = { enable = true },
        formatting = { enable = true },
        imports = { group = { enable = false } },
        completion = { postfix = { enable = false } },
      },
    },
  })

  vim.lsp.config('lua_ls', {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config('pyright', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
  })

  vim.lsp.config('yamlls', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*/action.{yml,yaml}",
          ["https://json.schemastore.org/circleciconfig.json"] = "/.circleci/config.yml",
        },
      },
    },
  })

  for _, name in ipairs({ 'ts_ls', 'rust_analyzer', 'lua_ls', 'pyright', 'yamlls' }) do
    vim.lsp.enable(name)
  end

  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  

  require("noice").setup({
    cmdline = { enabled = false },
    messages = { enabled = false, },
    views = {
      hover = {
        size = {
          max_height = 30,
          max_width = 80,
        },
      },
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    routes = {
      { filter = { event = "msg_show" },            opts = { skip = true } },
      { filter = { event = "msg_showmode" },        opts = { skip = true } },
      { filter = { event = "msg_history_show" },    opts = { skip = true } },
      { filter = { event = "search_count" },        opts = { skip = true } },
      { filter = { event = "cmdline" },             opts = { skip = true } },
      { filter = { event = "cmdline_show" },        opts = { skip = true } },
      { filter = { event = "cmdline_pos" },         opts = { skip = true } },
      { filter = { event = "cmdline_hide" },        opts = { skip = true } },
    },
  })

  require("dressing").setup({})

  require("actions-preview").setup({
    backend = { "nui", "telescope" },
  })

  local open_commit_in_browser = function()
    local async = require('gitsigns.async')

    async.create(0, function()
      local cache = require('gitsigns.cache').cache
      local bufnr = vim.api.nvim_get_current_buf()
      local bcache = cache[bufnr]

      if not bcache then
        print("Not in a git repository")
        return
      end

      -- Schedule to ensure we're in the right context
      if not bcache:schedule() then
        return
      end

      local lnum = vim.api.nvim_win_get_cursor(0)[1]

      -- get_blame is an async function that needs to be awaited
      local blame = bcache:get_blame(lnum)

      if not blame or not blame.commit or not blame.commit.sha then
        print("No commit found for this line")
        return
      end

      local sha = blame.commit.sha
      if sha == '0000000000000000000000000000000000000000' then
        print("Line not yet committed")
        return
      end

      local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("%s+", "")
      if remote_url == "" then
        print("No git remote found")
        return
      end

      -- Convert SSH or HTTPS URL to web URL
      local web_url = remote_url
        :gsub("^git@github%.com:", "https://github.com/")
        :gsub("^https://github%.com/", "https://github.com/")
        :gsub("%.git$", "")

      local commit_url = web_url .. "/commit/" .. sha
      vim.fn.system("open '" .. commit_url .. "'")
      print("Opening commit: " .. blame.commit.abbrev_sha)
    end)()
  end

  local open_file_in_browser = function()
    local filepath = vim.fn.expand('%:p')
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

    if vim.v.shell_error ~= 0 or not git_root then
      print("Not in a git repository")
      return
    end

    -- Get relative path from git root
    local relative_path = filepath:sub(#git_root + 2)

    -- Get current branch
    local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
    if vim.v.shell_error ~= 0 then
      print("Could not determine current branch")
      return
    end

    -- Get remote URL
    local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("%s+", "")
    if remote_url == "" then
      print("No git remote found")
      return
    end

    -- Convert SSH or HTTPS URL to web URL
    local web_url = remote_url
      :gsub("^git@github%.com:", "https://github.com/")
      :gsub("^https://github%.com/", "https://github.com/")
      :gsub("%.git$", "")

    -- Get current line number
    local line_num = vim.api.nvim_win_get_cursor(0)[1]

    local file_url = web_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. line_num
    vim.fn.system("open '" .. file_url .. "'")
    print("Opening: " .. relative_path .. "#L" .. line_num)
  end

  _G.open_file_range_in_browser = function()
    local filepath = vim.fn.expand('%:p')
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

    if vim.v.shell_error ~= 0 or not git_root then
      print("Not in a git repository")
      return
    end

    -- Get relative path from git root
    local relative_path = filepath:sub(#git_root + 2)

    -- Get current branch
    local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
    if vim.v.shell_error ~= 0 then
      print("Could not determine current branch")
      return
    end

    -- Get remote URL
    local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("%s+", "")
    if remote_url == "" then
      print("No git remote found")
      return
    end

    -- Convert SSH or HTTPS URL to web URL
    local web_url = remote_url
      :gsub("^git@github%.com:", "https://github.com/")
      :gsub("^https://github%.com/", "https://github.com/")
      :gsub("%.git$", "")

    -- Get visual selection line range
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    local file_url = web_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. start_line .. "-L" .. end_line
    vim.fn.system("open '" .. file_url .. "'")
    print("Opening: " .. relative_path .. "#L" .. start_line .. "-L" .. end_line)
  end

  -- Merge conflict resolution functions
  local function find_conflict_markers()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local conflict_start, conflict_middle, conflict_end

    -- Search backwards for conflict start
    for i = cursor_line, 1, -1 do
      if lines[i] and lines[i]:match("^<<<<<<<") then
        conflict_start = i
        break
      end
    end

    if not conflict_start then
      return nil
    end

    -- Search forward for middle and end from conflict start
    for i = conflict_start + 1, #lines do
      if lines[i] and lines[i]:match("^=======") and not conflict_middle then
        conflict_middle = i
      elseif lines[i] and lines[i]:match("^>>>>>>>") then
        conflict_end = i
        break
      end
    end

    if conflict_start and conflict_middle and conflict_end then
      return {
        start_line = conflict_start,
        middle_line = conflict_middle,
        end_line = conflict_end
      }
    end

    return nil
  end

  local function resolve_conflict(choice)
    local conflict = find_conflict_markers()
    if not conflict then
      print("No conflict found at cursor position")
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local current_changes = {}
    local incoming_changes = {}

    -- Extract current changes (between start and middle)
    for i = conflict.start_line + 1, conflict.middle_line - 1 do
      table.insert(current_changes, lines[i])
    end

    -- Extract incoming changes (between middle and end)
    for i = conflict.middle_line + 1, conflict.end_line - 1 do
      table.insert(incoming_changes, lines[i])
    end

    local resolution = {}
    if choice == "current" then
      resolution = current_changes
    elseif choice == "incoming" then
      resolution = incoming_changes
    elseif choice == "both" then
      vim.list_extend(resolution, current_changes)
      vim.list_extend(resolution, incoming_changes)
    end

    -- Replace the conflict with the resolution
    vim.api.nvim_buf_set_lines(bufnr, conflict.start_line - 1, conflict.end_line, false, resolution)

    print("Conflict resolved: accepted " .. choice)
  end

  vim.keymap.set('n', '<leader>mc', function() resolve_conflict('current') end,
    { desc = "Accept current changes" })
  vim.keymap.set('n', '<leader>mi', function() resolve_conflict('incoming') end,
    { desc = "Accept incoming changes" })
  vim.keymap.set('n', '<leader>mb', function() resolve_conflict('both') end,
    { desc = "Accept both changes" })

  -- Navigate to next/prev changed hunk across all git-tracked buffers in the repo
  local function nav_hunk_repo(direction)
    local cache = require('gitsigns.cache').cache
    local current_buf = vim.api.nvim_get_current_buf()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    -- Collect all (bufnr, lnum) pairs for hunks across all tracked buffers
    -- keyed by absolute filepath so we can sort them consistently
    local entries = {}
    for bufnr, bcache in pairs(cache) do
      local hunks = bcache.hunks or {}
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      for _, hunk in ipairs(hunks) do
        table.insert(entries, {
          bufnr = bufnr,
          filepath = filepath,
          lnum = math.max(hunk.added.start, 1),
        })
      end
    end

    if vim.tbl_isempty(entries) then
      vim.notify('No hunks in repo', vim.log.levels.INFO)
      return
    end

    -- Sort by filepath then lnum for deterministic ordering
    table.sort(entries, function(a, b)
      if a.filepath ~= b.filepath then return a.filepath < b.filepath end
      return a.lnum < b.lnum
    end)

    -- Find the index of the next/prev hunk relative to current position
    local current_path = vim.api.nvim_buf_get_name(current_buf)
    local target_idx = nil

    if direction == 'next' then
      for i, e in ipairs(entries) do
        if e.filepath > current_path or (e.filepath == current_path and e.lnum > current_line) then
          target_idx = i
          break
        end
      end
      if not target_idx then target_idx = 1 end  -- wrap around
    else
      for i = #entries, 1, -1 do
        local e = entries[i]
        if e.filepath < current_path or (e.filepath == current_path and e.lnum < current_line) then
          target_idx = i
          break
        end
      end
      if not target_idx then target_idx = #entries end  -- wrap around
    end

    local target = entries[target_idx]
    if vim.api.nvim_get_current_buf() ~= target.bufnr then
      vim.cmd('buffer ' .. target.bufnr)
    end
    vim.api.nvim_win_set_cursor(0, { target.lnum, 0 })
    vim.cmd('normal! zv')  -- open fold if needed
  end

  vim.keymap.set('n', '<leader>gn', function() nav_hunk_repo('next') end,
    { desc = 'Next hunk (repo-wide)', silent = true })
  vim.keymap.set('n', '<leader>gp', function() nav_hunk_repo('prev') end,
    { desc = 'Prev hunk (repo-wide)', silent = true })

  require("gitsigns").setup({
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
      end

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
      map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map("n", "<leader>gho", open_commit_in_browser, "Open Commit in Browser")
      map("n", "<leader>ghf", open_file_in_browser, "Open File in Browser")
      vim.keymap.set("x", "<leader>ghf", function()
        -- Store the current visual selection positions
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        -- Ensure start_line is less than end_line
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        -- Function will automatically exit visual mode after execution
        local filepath = vim.fn.expand('%:p')
        local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
        if vim.v.shell_error ~= 0 or not git_root then
          print("Not in a git repository")
          return
        end
        local relative_path = filepath:sub(#git_root + 2)
        local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
        if vim.v.shell_error ~= 0 then
          print("Could not determine current branch")
          return
        end
        local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("%s+", "")
        if remote_url == "" then
          print("No git remote found")
          return
        end
        local web_url = remote_url
          :gsub("^git@github%.com:", "https://github.com/")
          :gsub("^https://github%.com/", "https://github.com/")
          :gsub("%.git$", "")
        local file_url = web_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. start_line .. "-L" .. end_line
        vim.fn.system("open '" .. file_url .. "'")
        print("Opening: " .. relative_path .. "#L" .. start_line .. "-L" .. end_line)
      end, { buffer = buffer, desc = "Open File Range in Browser", silent = true })
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  })

  require("nvim-treesitter.configs").setup({
    ensure_installed = { 
      "rust","python","typescript","tsx",
      "lua","vim","vimdoc",
      "bash",
      "json","toml","markdown","markdown_inline",
      "diff","gitcommit",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  })

  require("treesitter-context").setup({
    enable = true,
    max_lines = 3,
    trim_scope = 'outer',
  })

  require("persistence").setup({
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize" },
  })
EOF
endif
