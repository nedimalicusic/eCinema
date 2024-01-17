using eCinema.Core;
using eCinema.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eCinema.Infrastructure
{
    public static class PagedListExtensions
    {
        public static async Task<PagedList<T>> ToPagedListAsync<T>(this IQueryable<T> queryable, BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var items = await queryable
                .Skip((searchObject.PageNumber - 1) * searchObject.PageSize)
                .Take(searchObject.PageSize)
                .ToListAsync(cancellationToken);

            var totalItemCount = await queryable.CountAsync(cancellationToken);

            var pagedList = new PagedList<T>();

            pagedList.Items = items;
            pagedList.PageNumber = searchObject.PageNumber;
            pagedList.PageSize = searchObject.PageSize;
            pagedList.TotalCount = totalItemCount;

            pagedList.PageCount = pagedList.TotalCount > 0 ? (int)Math.Ceiling(pagedList.TotalCount / (double)pagedList.PageSize) : 0;
            if (pagedList.PageCount <= 0 || pagedList.PageNumber > pagedList.PageCount)
                return pagedList;

            pagedList.HasPreviousPage = pagedList.PageNumber > 1;
            pagedList.HasNextPage = pagedList.PageNumber < pagedList.PageCount;

            pagedList.IsFirstPage = pagedList.PageNumber == 1;
            pagedList.IsLastPage = pagedList.PageNumber == pagedList.PageCount;

            return pagedList;
        }
    }
}
