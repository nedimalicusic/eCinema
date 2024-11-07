using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public class UsersRepository : BaseRepository<User, int, UserSearchObject>, IUsersRepository
    {
        public UsersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
        public async Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(s=>s.ProfilePhoto).AsNoTracking().FirstOrDefaultAsync(u => u.Email == email, cancellationToken);
        }

        public int getCountOfUsers(CancellationToken cancellationToken = default)
        {
            return DbSet.AsNoTracking().Count();
        }

        public int getCountOfUsersActive(CancellationToken cancellationToken = default)
        {
            return DbSet.Where(s => s.IsActive == true).AsNoTracking().Count();

        }
        public async Task<List<User>> GetUsersForSelection(CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(u => u.Role == Role.User).ToListAsync(cancellationToken);
        }

        public int getCountOfUsersInactive(CancellationToken cancellationToken = default)
        {
            return DbSet.Where(s => s.IsActive == false).AsNoTracking().Count();
        }

        public override async Task<PagedList<User>> GetPagedAsync(UserSearchObject searchObject, CancellationToken cancellationToken = default)
        {
             Role rola;

            if (searchObject.role == 0)
                rola = Role.Administrator;
            else
                rola = Role.User;

            return await DbSet.Include(s => s.ProfilePhoto)
                 .Where(u => (searchObject.name == null
                 || u.FirstName.ToLower().Contains(searchObject.name.ToLower())
                 || u.LastName.ToLower().Contains(searchObject.name.ToLower()))
                  && (searchObject.isActive == null || u.IsActive == searchObject.isActive)
                  && (searchObject.gender == null || u.Gender == searchObject.gender)
                  && (searchObject.isVerified == null || u.IsVerified == searchObject.isVerified)
                  && (u.Role == rola))
                  .ToPagedListAsync(searchObject, cancellationToken);


        }
        public override async Task<User?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(s => s.ProfilePhoto).FirstOrDefaultAsync(u => u.Id == id, cancellationToken);
        }
    }
}
