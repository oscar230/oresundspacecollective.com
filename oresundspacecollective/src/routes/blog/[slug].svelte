<script context="module" lang="ts">
    export async function load({ params }) {
      const { slug } = params;
      const post = await import(`../../../posts/${slug}.md`);
      return { post: post.default };
    }
  </script>
  
  <script lang="ts">
    export let data;
  </script>
  
  <div>
    {@html data.post}
  </div>
  