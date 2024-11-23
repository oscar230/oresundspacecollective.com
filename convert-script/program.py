import os
import re
from bs4 import BeautifulSoup
from datetime import datetime

def extract_metadata_and_content(html_content):
    """Extracts metadata and content from a WordPress HTML page."""
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Extract metadata
    title = soup.find('title').text if soup.find('title') else "Untitled Post"
    author = soup.find("a", class_="url fn n")
    author = author.text if author else "Unknown Author"
    date_tag = soup.find("time", class_="entry-date")
    date = date_tag['datetime'] if date_tag else "1970-01-01T00:00:00+00:00"
    date = datetime.fromisoformat(date.replace("Z", "+00:00"))  # Convert to datetime object
    
    # Extract content
    entry_content = soup.find(class_="entry-content")
    if not entry_content:
        return None
    
    # Remove unwanted tags (scripts, styles, navigation)
    for tag in entry_content.find_all(['script', 'style', 'nav']):
        tag.decompose()
    
    # Extract images
    for img_tag in entry_content.find_all("img"):
        src = img_tag.get("src")
        alt = img_tag.get("alt", "Image")
        img_markdown = f"![{alt}]({src})"
        img_tag.replace_with(img_markdown)
    
    # Convert content to Markdown
    content = str(entry_content)
    content = re.sub(r'<[^>]+>', '', content)  # Remove HTML tags
    
    return {
        "title": title,
        "author": author,
        "date": date,
        "content": content.strip()
    }

def html_to_markdown(input_folder, output_folder):
    """Converts all HTML files in the input folder to Markdown files in the output folder."""
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    for filename in os.listdir(input_folder):
        if filename.endswith(".html"):
            input_path = os.path.join(input_folder, filename)
            with open(input_path, 'r', encoding='utf-8') as file:
                html_content = file.read()
            
            # Extract data
            metadata = extract_metadata_and_content(html_content)
            if not metadata:
                print(f"Skipping {filename}: No valid content found.")
                continue
            
            # Generate Markdown filename
            post_date = datetime.fromisoformat(metadata['date'])
            slug = re.sub(r'[^a-zA-Z0-9]+', '-', metadata['title'].lower()).strip('-')
            markdown_filename = f"{post_date.strftime('%Y-%m-%d')}-{slug}.md"
            output_path = os.path.join(output_folder, markdown_filename)
            
            # Write to Markdown file
            with open(output_path, 'w', encoding='utf-8') as markdown_file:
                markdown_file.write(f"---\n")
                markdown_file.write(f"layout: post\n")
                markdown_file.write(f"title: \"{metadata['title']}\"\n")
                markdown_file.write(f"date: {metadata['date']}\n")
                markdown_file.write(f"author: \"{metadata['author']}\"\n")
                markdown_file.write(f"categories: news\n")
                markdown_file.write(f"---\n\n")
                markdown_file.write(metadata['content'])
            
            print(f"Converted {filename} to {markdown_filename}")

# Usage
input_folder = "../osc/_posts"
output_folder = "../osc/_posts"
html_to_markdown(input_folder, output_folder)
