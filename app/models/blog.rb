class Blog
  class << self
    def get_all
      keys = REDIS.keys("myblog:blog:*")
      blogs = []
      keys.each do |key|
        blogs.push(_read(key))
      end
      return blogs
    end
    
    def get(id)
      _read(_create_key(id))
    end
    
    def save(blog)
      key = "myblog:blog:" + blog["id"]
      _write(key,blog.to_json)
    end

    def build(params)
      blog = {}
      counter = REDIS.incr("myblog:totalcount")
      blog["id"] = counter.to_s
      blog["title"] = params["title"]
      blog["contents"] = params["contents"]
      blog["time"] = Time.now.utc
      blog["options"] = {}
      blog
    end
    
    private
    def _create_key(id)
      "myblog:blog:" + id
    end
        
    def _write(key, value)
      key = "myblog:blog:" + key unless key.match("^myblog:blog:/*")
      REDIS.set(key,value)
    end

    def _read(key)
      key = "myblog:blog:" + key unless key.match("^myblog:blog:/*")
      ActiveSupport::JSON.decode(REDIS.get(key))
    end
    
    def _del(key)
      key = "myblog:blog:" + key unless key.match("^myblog:blog:/*")
      if REDIS.del(key)
        ret = {"status" => "ok"}.to_json
      end
    end
  end
end