using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public abstract class BaseRepository<TEntity,TPrimaryKey,TSearchObject> : IBaseRepository<TEntity,TPrimaryKey,TSearchObject>
        where TEntity : BaseEntity
        where TSearchObject : BaseSearchObject
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<TEntity> DbSet;

        public BaseRepository(DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = databaseContext.Set<TEntity>();
        }
        public virtual async Task<TEntity?> GetByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default)
        {
            return await DbSet.FindAsync(id, cancellationToken);
        }

        public virtual async Task<PagedList<TEntity>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }

        public virtual async Task AddAsync(TEntity entity, CancellationToken cancellationToken = default)
        {
            entity.Id = default;
            await DbSet.AddAsync(entity, cancellationToken);
        }

        public virtual async Task AddRangeAsync(IEnumerable<TEntity> entities, CancellationToken cancellationToken = default)
        {
            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
        }

        public virtual void Update(TEntity entity)
        {
            DbSet.Update(entity);
        }

        public virtual void UpdateRange(IEnumerable<TEntity> entities)
        {
            DbSet.UpdateRange(entities);
        }

        public virtual void Remove(TEntity entity)
        {
            DbSet.Remove(entity);
        }

        public virtual async Task RemoveByIdAsync(TPrimaryKey id, bool isSoft = true, CancellationToken cancellationToken = default)
        {
            if (isSoft)
            {
                await DbSet.Where(e => e.Id.Equals(id)).ExecuteUpdateAsync(p => p
                    .SetProperty(e => e.IsDeleted, true)
                    .SetProperty(e => e.ModifiedAt, DateTime.Now), cancellationToken);
            }
            else
            {
                await DbSet.Where(e => e.Id.Equals(id)).ExecuteDeleteAsync(cancellationToken);
            }
        }
    }
}
