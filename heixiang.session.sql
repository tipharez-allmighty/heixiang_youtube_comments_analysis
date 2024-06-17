CREATE EXTENSION pgcrypto;
CREATE TYPE channel_affiliation AS ENUM('green','blue-white','neutral');

CREATE TABLE channels (
    channel_id VARCHAR(255) PRIMARY KEY NOT NULL,
    channel_name VARCHAR(255) NOT NULL,
    subscriberCount INT NOT NULL DEFAULT 0,
    pol_affiliation channel_affiliation
);

CREATE TABLE videos (
    video_id VARCHAR(255) PRIMARY KEY NOT NULL,
    channel_id VARCHAR(255) NOT NULL,
    video_title VARCHAR(255) NOT NULL,
    published_at TIMESTAMP NOT NULL,
    view_count INT NOT NULL DEFAULT 0,
    comment_count INT NOT NULL DEFAULT 0,
    like_count INT NOT NULL DEFAULT 0,
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

CREATE table comments (
    comment_id VARCHAR(255) PRIMARY KEY NOT NULL,
    video_id VARCHAR(255) NOT NULL,
    published_at TIMESTAMP NOT NULL,
    like_count INT NOT NULL DEFAULT 0,
    reply_count INT NOT NULL DEFAULT 0,
    comment_content TEXT NOT NULL,
    FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

CREATE VIEW channel_statistic AS
SELECT 
    c.channel_id, c.channel_name, c.subscriberCount, c.pol_affiliation,
    AVG(v.like_count) AS avg_likes_per_video, AVG(v.view_count) AS avg_views_per_video,
    AVG(v.comment_count) AS avg_comments_per_video,
    SUM(v.like_count) AS total_likes, SUM(v.view_count) AS total_views,
    SUM(v.comment_count) AS total_comments
FROM channels AS c
LEFT JOIN
    videos AS v ON c.channel_id = v.channel_id
GROUP BY
    c.channel_id, c.channel_name, c.subscriberCount, c.pol_affiliation;

