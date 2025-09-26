const axios = require('axios');
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./sellvpn.db');

async function createtrojan(username, exp, quota, limitip, serverId) {
  console.log(`⚙️ Creating TROJAN for ${username} | Exp: ${exp} | Quota: ${quota} GB | IP Limit: ${limitip}`);

  if (/\s/.test(username) || /[^a-zA-Z0-9]/.test(username)) {
    return '❌ Username tidak valid.';
  }

  return new Promise((resolve) => {
    db.get('SELECT * FROM Server WHERE id = ?', [serverId], async (err, server) => {
      if (err || !server) return resolve('❌ Server tidak ditemukan.');

      const url = `http://${server.domain}:5888/createtrojan?user=${username}&exp=${exp}&quota=${quota}&iplimit=${limitip}&auth=${server.auth}`;

      try {
        const { data } = await axios.get(url);

        if (data.status !== 'success') return resolve(`❌ Gagal: ${data.message}`);

        const d = data.data;

  // Pesan teks Trojan
const messageTextTrojan = `
🌟 *AKUN TROJAN PREMIUM* 🌟

┌───☠️───────────────☠️───┐
│ *Username*  : \`${trojanData.username}\`
│ *Domain*    : \`${trojanData.domain}\`
│ *Port TLS*  : \`443\`
│ *Port HTTP* : \`80\`
│ *Security*  : \`Auto\`
│ *Network*   : \`Websocket (WS)\`
│ *Path*      : \`/trojan-ws\`
│ *Path GRPC* : \`trojan-grpc\`
└─────💀─────☠️────💀────┘

⚙️ *Petunjuk Singkat*
• Salin credential di atas dan pakai path \`/trojan-ws\` untuk WebSocket.
• Untuk bantuan atau konfigurasi lanjut, klik tombol di bawah ini.
`;

// Inline button
const replyMarkupTrojan = {
  inline_keyboard: [
    [
      { text: "Hubungi Admin", url: "https://t.me/rahmarie" }
    ]
  ]
};

// Kirim pesan
bot.sendMessage(chatId, messageTextTrojan, {
  parse_mode: "Markdown",
  reply_markup: replyMarkupTrojan
});

🔗 *TROJAN TLS:*
\`\`\`
${d.trojan_tls_link}
\`\`\`
🔗 *TROJAN GRPC:*
\`\`\`
${d.trojan_grpc_link}
\`\`\`

🔏 *PUBKEY:* \`${d.pubkey}\`
┌─────────────────────
│🕒 *Expired:* \`${d.expired}\`
│
│📥 [Save Account](https://${d.domain}:81/trojan-${d.username}.txt)
└─────────────────────
✨ By : *SAGI MARKET VVIP*! ✨
`.trim();

        resolve(msg);
      } catch (e) {
        resolve('❌ Tidak bisa request trojan.');
      }
    });
  });
}

module.exports = { createtrojan };