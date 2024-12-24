return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            -- REQUIRED
            harpoon:setup()
            -- REQUIRED

            Map("n", "<leader>a", function() harpoon:list():add() end)
            Map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            Map("n", "<C-h>", function() harpoon:list():select(1) end)
            Map("n", "<C-t>", function() harpoon:list():select(2) end)
            Map("n", "<C-n>", function() harpoon:list():select(3) end)
            Map("n", "<C-s>", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            Map("n", "<C-S-P>", function() harpoon:list():prev() end)
            Map("n", "<C-S-N>", function() harpoon:list():next() end)
        end,
    },
}
