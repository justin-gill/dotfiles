return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false }, -- Disable ghost text - use cmp only
                panel = { enabled = false },
            })
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "zbirenbaum/copilot.lua",
        },
        opts = {},
        keys = {
            -- Action palette
            { "<C-a>", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
            -- Chat
            { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat Toggle", mode = { "n", "v" } },
            { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = "v" },
            -- Inline assistant
            { "<leader>ci", "<cmd>CodeCompanion<cr>", desc = "CodeCompanion Inline", mode = { "n", "v" } },
            -- Quick actions
            { "<leader>ce", "<cmd>CodeCompanionChat /explain<cr>", desc = "Explain Code", mode = { "n", "v" } },
            { "<leader>cf", "<cmd>CodeCompanionChat /fix<cr>", desc = "Fix Code", mode = { "n", "v" } },
            { "<leader>ct", "<cmd>CodeCompanionChat /tests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
            { "<leader>cm", "<cmd>CodeCompanionChat /commit<cr>", desc = "Generate Commit", mode = { "n", "v" } },
        },
    },
}
