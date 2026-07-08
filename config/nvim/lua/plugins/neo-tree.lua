return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["<leader>?"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()

            -- Check if file exists and is an image
            local ext = path:match("%.(%w+)$")
            local image_exts = {
              png = true, jpg = true, jpeg = true, gif = true,
              bmp = true, tiff = true, tif = true, webp = true,
              svg = true, ico = true, heic = true, heif = true,
            }

            if not ext or not image_exts[ext:lower()] then
              vim.notify("Not an image file", vim.log.levels.WARN)
              return
            end

            -- Get image dimensions using ImageMagick identify
            local handle = io.popen('identify -format "%wx%h" "' .. path .. '" 2>/dev/null')
            if handle then
              local result = handle:read("*a")
              handle:close()

              if result and result ~= "" then
                vim.fn.setreg("+", result)
                vim.notify("Copied: " .. result, vim.log.levels.INFO)
              else
                vim.notify("Could not get image dimensions", vim.log.levels.ERROR)
              end
            else
              vim.notify("Failed to run identify command", vim.log.levels.ERROR)
            end
          end,
          desc = "Copy Image Dimensions",
        },
      },
    },
  },
}
