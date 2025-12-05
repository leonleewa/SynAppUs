# AI Agent Usage Documentation

## MCP Chrome Extension - Screenshot Best Practices

### Full Page Screenshots

**Successful Approach:**

```javascript
// Use simple parameters
{
  fullPage: true,
  savePng: true,
  name: "filename"  // Just the filename, no path
}
```

**Key Points:**

1. **Be patient** - Full page screenshots take longer to process (can exceed 30s timeout initially)
2. **Use simple parameters** - Don't overcomplicate with unnecessary options
3. **File location** - Screenshots save to Downloads folder by default
4. **Move the file** - Use bash `move` command to relocate to desired directory:
   ```bash
   move "C:\Users\[User]\Downloads\[filename].png" "C:\Development\Project\[filename].png"
   ```

**What NOT to Do:**

- ❌ Don't specify full file paths in the `name` parameter
- ❌ Don't use `storeBase64` for full page screenshots (causes timeout)
- ❌ Don't add unnecessary width/height parameters for full page captures
- ❌ Don't give up after first timeout - retry with simpler parameters

**Example Sequence:**

1. Take screenshot with simple parameters
2. Wait for success response with download filename
3. Move file from Downloads to target directory

### Regular Screenshots

For viewport-only screenshots, you can use additional parameters:
- `width` and `height` for specific dimensions
- `fullPage: false` for faster capture
- `selector` for specific element screenshots

---

*Last updated: 2025-12-04*
