// config.js
const CONFIG = {
  repo: '你的用户名/你的仓库名',  // 例如: 'zhangsan/earth-ol'
  owner: '你的GitHub用户名'
};

// api.js
async function fetchComments(targetId) {
  const url = `https://api.github.com/repos/${CONFIG.owner}/${CONFIG.repo}/issues?labels=${targetId}&state=all`;
  const response = await fetch(url);
  const issues = await response.json();
  
  return issues.map(issue => ({
    id: issue.number,
    author: issue.user.login,
    avatar: issue.user.avatar_url,
    content: issue.body,
    score: extractScoreFromLabels(issue.labels), // 从标签提取评分
    createdAt: issue.created_at,
    likes: issue.reactions ? issue.reactions.total_count : 0
  }));
}

// 发布评论（需要 GitHub Token）
async function postComment(targetId, title, body, score, token) {
  const url = `https://api.github.com/repos/${CONFIG.owner}/${CONFIG.repo}/issues`;
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Authorization': `token ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      title: title,
      body: body,
      labels: [targetId, `score-${score}`]
    })
  });
  return response.json();
}
