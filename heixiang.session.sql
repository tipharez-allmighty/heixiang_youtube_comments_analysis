CREATE EXTENSION pgcrypto;
CREATE TYPE channel_affiliation AS ENUM('green','blue-white','neutral');

CREATE TABLE channels (
    channel_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_subscribers INT NOT NULL DEFAULT 0,
    channel_name VARCHAR(255) NOT NULL,
    pol_affiliation channel_affiliation
);

CREATE TABLE videos (
    video_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_id UUID NOT NULL,
    video_title VARCHAR(255) NOT NULL,
    date TIMESTAMP NOT NULL,
    views INT NOT NULL DEFAULT 0,
    comments_amount INT NOT NULL DEFAULT 0,
    likes INT NOT NULL DEFAULT 0,
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

CREATE table comments (
    comment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id UUID NOT NULL,
    date TIMESTAMP NOT NULL,
    likes INT NOT NULL DEFAULT 0,
    replies INT NOT NULL DEFAULT 0,
    comment_content TEXT NOT NULL,
    FOREIGN KEY (video_id) REFERENCES videos(video_id)
);

CREATE VIEW channel_statistic AS
SELECT 
    c.channel_id, c.channel_name, c.channel_subscribers, c.pol_affiliation,
    AVG(v.likes) AS avg_likes_per_video, AVG(v.views) AS avg_views_per_video,
    AVG(v.comments_amount) AS avg_comments_per_video,
    SUM(v.likes) AS total_likes, SUM(v.views) AS total_views,
    SUM(v.comments_amount) AS total_comments
FROM channels AS c
LEFT JOIN
    videos AS v ON c.channel_id = v.channel_id
GROUP BY
    c.channel_id, c.channel_name, c.channel_subscribers, c.pol_affiliation;




DROP TABLE videos, channels, comments;
DROP TYPE channel_affiliation;