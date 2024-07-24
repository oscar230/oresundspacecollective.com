<script context="module" lang="ts">
    import fs from 'fs';
    import path from 'path';
  
    export async function load() {
      const files = fs.readdirSync('posts').filter(file => file.endsWith('.md'));
  
      const posts = files.map(file => {
        const { metadata } = import(`../../../posts/${file}`);
        return { slug: file.replace('.md', ''), metadata };
      });
  
      return { posts: await Promise.all(posts) };
    }
  </script>
  
  <script lang="ts">
    export let data;
  </script>
  
  <ul>
    {#each data.posts as { slug, metadata }}
      <li>
        <a href={`/blog/${slug}`}>{metadata.title}</a>
        <p>{metadata.date}</p>
      </li>
    {/each}
  </ul>
  