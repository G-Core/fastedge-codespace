# GitHub Codespaces ♥️ FastEdge

Welcome to your FastEdge Application codespace. We've got everything setup and running for you to explore FastEdge development.

You've got a blank canvas to work on from a git perspective as well. There's a single initial commit with the what you're seeing right now - where you go from here is up to you!

Everything you do here is contained within this one codespace. There is no repository on GitHub yet. If and when you're ready you can click "Publish Branch" and we'll create your repository and push up your project. If you were just exploring then and have no further need for this code then you can simply delete your codespace and it's gone forever.

The "startup" script will start shortly and help you get started coding your first application.

There is also an MCP Server attached [fastedge-assistant](https://github.com/G-Core/FastEdge-mcp-server) that helps you develop (vibe-code) applications and deploy them to our network.

## Signing in

The MCP server doesn't need an API key. When it first needs your Gcore account, Copilot gives you a portal link and a `login --code` command. Open the link in your browser, choose the manual option and approve, then run the command in the terminal and paste the connect code at its prompt.

- Never paste the connect code into the chat: it is your access token.
- The session lasts at most 8 hours and is kept only in the running MCP server's memory. Nothing usable is saved in this codespace, so you approve again each time the MCP server restarts.

## Next Steps

To help you write code that matches the FastEdge API please use our MCP Server, it contains all of our examples and SDK knowledge within it's context.

Try the co-pilot chat command:

```ai
What FastEdge tools do you have?
```

You will now see that this MCP Server can also help you deploy applications directly to the edge network.

```ai
/deployFastEdgeApp
```

## Other useful tools

Apart from the [FastEdge MCP Server](https://github.com/G-Core/FastEdge-mcp-server) there is also the [FastEdge VS Code extension](https://github.com/G-Core/FastEdge-vscode) installed.

This allows you to run HTTP Applications right here in the codespace / editor.

Press `F1` and then type "FastEdge" to list the available commands.
